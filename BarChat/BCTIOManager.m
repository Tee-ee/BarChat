//
//  BCTIOManager.m
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTIOManager.h"
#import "BCTDatabaseManager.h"
#import "BCTSocketManager.h"
#import "BCTUser.h"
#import "BCTDateManager.h"
#import "BCTMessage.h"
#import "BCTFrame.h"
#import "BCTVCManager.h"
#import "BCTMacros.h"

@interface BCTIOManager() <BCTSocketManagerDelegate>

@property (nonatomic, strong) BCTDatabaseManager*   dbManager;

@property (nonatomic, strong) BCTSocketManager*     socketManager;

@property (nonatomic, strong) NSMutableDictionary*  unconfiguredMessages;

@property (nonatomic, assign) int                   tempID;

@end

@implementation BCTIOManager
{

}
+ (instancetype)sharedManager {
    static dispatch_once_t pred;
    static BCTIOManager* manager = nil;
    
    dispatch_once(&pred, ^{
        manager = [[BCTIOManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _dbManager = [[BCTDatabaseManager alloc] init];
        _socketManager = [[BCTSocketManager alloc] init];
        _socketManager.delegate = self;
        _unconfiguredMessages = [NSMutableDictionary dictionary];
        _tempID = -1;
    }
    return self;
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    _phoneNumber = phoneNumber;
    [_dbManager setupForPhoneNumber:phoneNumber];
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:kBCTHasAddCreatorKey] boolValue]) {
        [self makeFriendWithCreator];
    }
    [self connect];
}

- (int)tempID {
    return _tempID--;
}

- (void)connect {
    [self.socketManager connect];
}
#pragma mark BCTSocketManagerDelegate

- (void)socketManager:(BCTSocketManager *)manager didConnectToHost:(NSString *)host {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self postIdentification];
    });
}

- (void)socketManager:(BCTSocketManager *)manager cannotConnectToHost:(NSString *)host {
}

- (void)socketManager:(BCTSocketManager *)manager didReceivedData:(NSData *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray* frames = [BCTFrame framesWithData:data];
        for (BCTFrame* frame in frames) {
            switch (frame.type) {
                case BCTFrameTypeIdentification:
                    [self fetchUnreadMessage:frame];
                    break;
                    
                case BCTFrameTypePeerMessage:
                    [self receivePeerMessage:frame];
                    break;
                    
                case BCTFrameTypeMessageConfigure:
                    [self configureMessage:frame];
                    break;
                    
                default:
                    break;
            }
        }
    });
}

#pragma mark output data

- (void)sendFrame:(BCTFrame*)frame {
    NSData* data = [frame frameData];
    [self.socketManager sendData:data];
}

- (void)postIdentification {
    BCTFrame* identificationFrame = [BCTFrame identificationFrameWithPhoneNumber:self.phoneNumber];
    [self sendFrame:identificationFrame];
}

- (void)sendMessage:(NSString *)content to:(NSString *)peerPhoneNumber {
    if (!self.socketManager.isInernetReachable) {
        NSLog(@"[FAILED] trying to send message when Internet unreachable");
        return;
    }
    int tempID = self.tempID;
    BCTMessage* message = [BCTMessage messageWithID:tempID from:self.phoneNumber to:peerPhoneNumber content:content date:[[BCTDateManager sharedManager] relativeTimeInterval] type:BCTMessageTypeText];
    [[BCTVCManager sharedManager] addMessage:message];
    BCTFrame* frame = [BCTFrame messageFrameWithMessage:[message description]];
    [self sendFrame:frame];
    [self.unconfiguredMessages setValue:message forKey:[@(tempID) stringValue]];
    
}

- (void)postFriendRequestTo:(NSString *)peerPhoneNumber {
    
}

#pragma mark input data 
- (void)fetchUnreadMessage:(BCTFrame*)frame {
    if ([[frame.data valueForKey:@"success"] boolValue]) {
        [[BCTVCManager sharedManager] refreshVCs];
    }
}

- (void)configureMessage:(BCTFrame*)frame {
    NSInteger tempID = [[frame.data valueForKey:@"tempID"] integerValue];
    NSInteger currentID = [[frame.data valueForKey:@"currentID"] integerValue];
    BCTMessage* message = [self.unconfiguredMessages valueForKey:[@(tempID) stringValue]];
    [message configureID:currentID];
    [self.dbManager addMessageFrom:message.from to:message.to ID:message.ID content:message.content date:message.date type:message.type toMe:[message.to isEqualToString:self.phoneNumber]];
    [self.unconfiguredMessages removeObjectForKey:[@(tempID) stringValue]];
    NSLog(@"[SUCCEED] configured message from %ld to %ld", tempID, currentID);
}

- (void)receivePeerMessage:(BCTFrame*)frame {
    BCTMessage* message = [BCTMessage messageWithJSON:frame.data];
    [self.dbManager addMessageFrom:message.from to:message.to ID:message.ID content:message.content date:message.date type:message.type toMe:[message.to isEqualToString:self.phoneNumber]];
    [[BCTVCManager sharedManager] addMessage:message];
}

#pragma mark main functionality

- (void)makeFriendWithCreator {
    [self makeFriendWith:[BCTUser userWithUserName:@"Creator" phoneNumber:@"15689932457" gender:@"m" photo:0]];
    [[NSUserDefaults standardUserDefaults] setValue:@true forKey:kBCTHasAddCreatorKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)makeFriendWith:(BCTUser*)user {
    [self.dbManager addFriendWithPhoneNumber:user.phoneNumber userName:user.userName gender:user.gender icon:user.photo];
    [self.dbManager addMessageFrom:user.phoneNumber to:self.phoneNumber ID:0 content:@"我们现在是朋友了~" date:[[BCTDateManager sharedManager] relativeTimeInterval] type:BCTMessageTypeText toMe:YES];
}

- (NSArray*)getConversations {
    return [self.dbManager queryConversations];
}

- (NSArray*)getMessagesWithPhoneNumber:(NSString *)peerPhoneNumber {
    return [self.dbManager queryMessagesWithPhoneNumber:peerPhoneNumber];
}

- (void)setBubbleHeight:(double)height
             forMessage:(NSInteger)ID
      friendPhoneNumber:(NSString *)phoneNumber {
    [self.dbManager setBubbleHeight:height forMessage:ID friendPhoneNumber:phoneNumber];
}

@end
