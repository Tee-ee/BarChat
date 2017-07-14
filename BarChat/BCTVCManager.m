//
//  BCTVCManager.m
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTVCManager.h"
#import "BCTNavigationVC.h"
#import "BCTChatVC.h"
#import "BCTChatListVC.h"
#import "BCTMessage.h"
#import "BCTMacros.h"

@interface BCTVCManager()

@property (nonatomic, strong) BCTChatVC* chatVC;


@end

@implementation BCTVCManager

+ (instancetype)sharedManager {


    static dispatch_once_t pred;
    static BCTVCManager* manager = nil;
    
    dispatch_once(&pred, ^{
        manager = [[BCTVCManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _chatVC = [[BCTChatVC alloc] init];
    }
    
    return self;
}

- (void)pushToChatVCWithPeerPhoneNumber:(NSString *)phoneNumber displayName:(NSString *)displayName {
    self.chatVC.displayName = displayName;
    self.chatVC.peerPhoneNumber = phoneNumber;
    [self.navigationVC pushViewController:self.chatVC animated:YES];
}

- (void)alertForInternetUnreachable {
    
}

- (void)addMessage:(BCTMessage *)message {
    if (![self.chatVC.peerPhoneNumber isEqualToString:message.from] && ![self.chatVC.peerPhoneNumber isEqualToString:message.to]) {
        return;
    }
    [self.chatVC addMessage:message];
}

- (void)refreshVCs {
    [self.chatListVC refresh];
}

@end
