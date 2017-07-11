//
//  BCTMessage.h
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BCTMessageType) {
    BCTMessageTypeText,
    BCTMessageTypeImage
};

@interface BCTMessage : NSObject

@property (nonatomic, assign, readonly) NSUInteger        ID;

@property (nonatomic, strong, readonly) NSString*         from;

@property (nonatomic, strong, readonly) NSString*         to;

@property (nonatomic, strong, readonly) NSString*         content;

@property (nonatomic, assign) NSTimeInterval    date;

@property (nonatomic, assign, readonly) BCTMessageType    type;

@property (nonatomic, strong, readonly) NSString*         displayName;

@property (nonatomic, assign)           CGFloat           bubbleHeight;

@property (nonatomic, assign)           BOOL              isAnimated;

+ (instancetype)messageWithJSON:(NSDictionary*)json;

@end
