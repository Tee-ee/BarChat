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
    if (kBCTDebugMode) {
        NSLog(@"[SUCCEED] creating message with json: %@", json);
    }
    
    return message;
}

+ (instancetype)messageWithID:(NSInteger)ID from:(NSString*)from to:(NSString*)to content:(NSString*)content date:(NSTimeInterval)date type:(BCTMessageType)type {
    BCTMessage* message = [[BCTMessage alloc] initWithID:ID from:from to:to content:content date:date type:type];
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

- (instancetype)initWithID:(NSInteger)ID from:(NSString*)from to:(NSString*)to content:(NSString*)content date:(NSTimeInterval)date type:(BCTMessageType)type {
    if (self = [super init]) {
        _ID = ID;
        _from = from;
        _to = to;
        _content = content;
        _date = date;
        _type = type;
    }
    return self;
}

- (void)configureID:(NSInteger)ID {
    _ID = ID;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"{\"ID\":%ld,\"from\":\"%@\",\"to\":\"%@\",\"content\":\"%@\",\"date\":%f,\"type\":%lu}",(long)_ID,_from,_to,_content,_date,(unsigned long)_type];
}

@end
