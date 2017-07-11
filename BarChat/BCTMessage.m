//
//  BCTMessage.m
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTMessage.h"
#import "BCTMacros.h"

@implementation BCTMessage

+ (instancetype)messageWithJSON:(NSDictionary*)json {
    BCTMessage* message = [[BCTMessage alloc] init];
    [message setValuesForKeysWithDictionary:json];
    message.isAnimated = NO;
    if (kBCTDebugMode) {
        NSLog(@"[SUCCEED] creating message with json: %@", json);
    }
    
    return message;
}

- (instancetype)init {
    if (self = [super init]) {
        _date = 0;
        _bubbleHeight = 0;
        _isAnimated = YES;
    }
    return self;
}
@end
