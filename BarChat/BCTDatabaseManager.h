//
//  BCTDatabaseManager.h
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCTDatabaseManager : NSObject

- (BOOL)setupForPhoneNumber:(NSString*)phoneNumber;

- (BOOL)closeDatabase;

- (BOOL)addFriendWithPhoneNumber:(NSString*)phoneNumber userName:(NSString*)userName gender:(NSString*)gender icon:(int)icon;

- (BOOL)addMessageFrom:(NSString*)from to:(NSString*)to ID:(NSInteger)ID content:(NSString*)content date:(NSTimeInterval)date type:(NSUInteger)type toMe:(BOOL)toMe;

- (NSArray*)queryConversations;

- (NSArray*)queryMessagesWithPhoneNumber:(NSString*)peerPhoneNumber;
@end
