//
//  BCTMessage.h
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef BCTMessageType

typedef NS_ENUM(NSUInteger, BCTMessageType) {
    BCTMessageTypeText,
    BCTMessageTypeImage
};

#endif

@interface BCTMessage : NSObject

@property (nonatomic, assign, readonly) NSInteger        ID;

@property (nonatomic, strong, readonly) NSString*         from;

@property (nonatomic, strong, readonly) NSString*         to;

@property (nonatomic, strong, readonly) NSString*         content;

@property (nonatomic, assign) NSTimeInterval    date;

@property (nonatomic, assign, readonly) BCTMessageType    type;

@property (nonatomic, assign)           CGFloat           bubbleHeight;

@property (nonatomic, assign)           BOOL              isAnimated;

+ (instancetype)messageWithJSON:(NSDictionary*)json;

+ (instancetype)messageWithID:(NSInteger)ID from:(NSString*)from to:(NSString*)to content:(NSString*)content date:(NSTimeInterval)date type:(BCTMessageType)type;

- (void)configureID:(NSInteger)ID;
@end
