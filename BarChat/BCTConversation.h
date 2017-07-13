//
//  BCTConversation.h
//  BarChat
//
//  Created by Vince on 7/12/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BCTMessageType

typedef NS_ENUM(NSUInteger, BCTMessageType) {
    BCTMessageTypeText,
    BCTMessageTypeImage
};

#endif

@interface BCTConversation : NSObject

@property (nonatomic, strong, readonly) NSString* phoneNumber;

@property (nonatomic, strong, readonly) NSString* displayName;

@property (nonatomic, strong, readonly) NSString* content;

@property (nonatomic, assign, readonly) int       photo;

@property (nonatomic, assign, readonly) NSTimeInterval  date;

@property (nonatomic, assign, readonly) BCTMessageType  type;

+ (instancetype)conversationWithPhoneNumber:(NSString*)phoneNumber name:(NSString*)name content:(NSString*)content photo:(int)photo date:(NSTimeInterval)date type:(BCTMessageType)type;

+ (instancetype)conversationWithDic:(NSDictionary*)dict;
@end
