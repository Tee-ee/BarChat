//
//  BCTIOManager.h
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCTIOManager : NSObject

@property (nonatomic, strong) NSString* phoneNumber;

+ (instancetype)sharedManager;

@end
