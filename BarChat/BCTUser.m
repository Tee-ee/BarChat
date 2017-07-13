//
//  BCTUser.m
//  BarChat
//
//  Created by Vince on 7/11/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTUser.h"
#import "BCTMacros.h"

@implementation BCTUser

+ (instancetype)userWithJSON:(NSDictionary*)json {
    BCTUser* user = [[BCTUser alloc] init];
    [user setValuesForKeysWithDictionary:json];
    user.nickName = @"";
    if (kBCTDebugMode) {
        NSLog(@"[SUCCEED] creating user with json: %@", json);
    }
    
    return user;
}

+ (instancetype)userWithUserName:(NSString*)userName phoneNumber:(NSString*)phoneNumber gender:(NSString*)gender photo:(int)photo {
    return [[BCTUser alloc] initWithUserName:userName phoneNumber:phoneNumber gender:gender photo:photo];
}

- (instancetype)initWithUserName:(NSString*)userName phoneNumber:(NSString*)phoneNumber gender:(NSString*)gender photo:(int)photo {
    if (self = [super init]) {
        _userName = userName;
        _phoneNumber = phoneNumber;
        _gender = gender;
        _photo = photo;
    }
    return self;
}


@end
