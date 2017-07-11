//
//  BCTVCManager.h
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCTNavigationVC;

@interface BCTVCManager : NSObject

@property (nonatomic, weak) __kindof UINavigationController*    navigationVC;

@property (nonatomic, strong) NSString*                         userPhoneNumber;

+ (instancetype)sharedManager;

- (void)pushToChatVCWithPeerPhoneNumber:(NSString*)phoneNumber;

@end
