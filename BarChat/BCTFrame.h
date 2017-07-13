//
//  BCTFrame.h
//  BarChat
//
//  Created by Vince on 7/11/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BCTFrameType) {
    BCTFrameTypeIdentification = 0,
    BCTFrameTypePeerMessage,
    BCTFrameTypeLogin,
    BCTFrameTypeRegister,
    BCTFrameTypeSearchUser,
    BCTFrameTypeFriendRequest,
    BCTFrameTypeFriendResponse,
    BCTFrameTypeFriendRefuse,
    BCTFrameTypeTokenAssign,
    BCTFrameTypeMessageConfigure,
    BCTFrameTypeError
};

@interface BCTFrame : NSObject

@property (nonatomic, assign, readonly) BCTFrameType    type;

@property (nonatomic, strong, readonly) id         data;

@property (nonatomic, strong, readonly) NSString*       token;

@property (nonatomic, assign, readonly) int             version;

@property (nonatomic, strong, readonly) NSData*         frameData;

+ (NSArray*)framesWithData:(NSData*)data;

+ (instancetype)identificationFrameWithPhoneNumber:(NSString*)phoneNumber;

+ (instancetype)messageFrameWithMessage:(NSString*)message;
@end
