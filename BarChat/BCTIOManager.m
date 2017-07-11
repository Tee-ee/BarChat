//
//  BCTIOManager.m
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTIOManager.h"
#import "BCTDatabaseManager.h"

@interface BCTIOManager()

@property (nonatomic, strong) BCTDatabaseManager* dbManager;

@end

@implementation BCTIOManager

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
    }
    return self;
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    _phoneNumber = phoneNumber;
    [_dbManager setupForPhoneNumber:phoneNumber];
}

@end
