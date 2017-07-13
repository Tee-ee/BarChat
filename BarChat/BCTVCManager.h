//
//  BCTVCManager.h
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCTMainVC;
@class BCTChatListVC;
@class BCTFriendsVC;
@class BCTDiscoveryVC;
@class BCTMessage;

@interface BCTVCManager : NSObject

@property (nonatomic, weak) __kindof UINavigationController*    navigationVC;

@property (nonatomic, weak) BCTMainVC*                          mainVC;

@property (nonatomic, weak) BCTChatListVC*                      chatListVC;

@property (nonatomic, weak) BCTFriendsVC*                       friendsVC;

@property (nonatomic, weak) BCTDiscoveryVC*                     discoveryVC;

+ (instancetype)sharedManager;

- (void)pushToChatVCWithPeerPhoneNumber:(NSString*)phoneNumber;

- (void)alertForInternetUnreachable;

- (void)addMessage:(BCTMessage*)message;

- (void)refreshVCs;

@end
