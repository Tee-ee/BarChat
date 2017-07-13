//
//  BCTConversation.m
//  BarChat
//
//  Created by Vince on 7/12/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTConversation.h"

@implementation BCTConversation

+ (instancetype)conversationWithPhoneNumber:(NSString *)phoneNumber name:(NSString *)name content:(NSString *)content photo:(int)photo date:(NSTimeInterval)date type:(BCTMessageType)type{
    BCTConversation* conversation = [[BCTConversation alloc] initWithPhoneNumber:phoneNumber name:name content:content photo:photo date:date type:type];
    return conversation;
}

+ (instancetype)conversationWithDic:(NSDictionary *)dict {
    BCTConversation* conversation = [[BCTConversation alloc] init];
    [conversation setValuesForKeysWithDictionary:dict];
    return conversation;
}

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber name:(NSString *)name content:(NSString *)content photo:(int)photo date:(NSTimeInterval)date type:(BCTMessageType)type {
    if (self = [super init]) {
        _phoneNumber = phoneNumber;
        _displayName = name;
        _content = content;
        _photo = photo;
        _date = date;
    }
    return self;
}

@end
