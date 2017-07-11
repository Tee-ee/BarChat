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

- (void)pushToChatVCWithPeerPhoneNumber:(NSString *)phoneNumber {
    [self.navigationVC pushViewController:self.chatVC animated:YES];
    self.chatVC.peerPhoneNumber = phoneNumber;
}

@end
