//
//  BCTChatVC.h
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCTMessage;
@interface BCTChatVC : UIViewController

@property (nonatomic, strong) NSString* peerPhoneNumber;

@property (nonatomic, strong) NSString* displayName;

- (void)addMessage:(BCTMessage*)message;

- (void)refresh;

@end
