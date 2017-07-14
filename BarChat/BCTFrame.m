//
//  BCTFrame.m
//  BarChat
//
//  Created by Vince on 7/11/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTFrame.h"
#import "BCTMacros.h"
#import <string.h>

@implementation BCTFrame

#pragma mark input frame

+ (NSArray*)framesWithData:(NSData *)data {
    NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (kBCTDebugMode) {
        NSLog(@"[NOTICE] receive json sequence: %@", jsonString);
    }
    
    const char* jsonUFT8String = [jsonString UTF8String];
    NSMutableArray* frames = [NSMutableArray array];
    for (int i = 0; i < strlen(jsonUFT8String); i++) {
        int stringLength = 1;
        while (jsonUFT8String[i + stringLength] != '#') {
            stringLength ++;
        }
        
        char* lengthUFT8String = (char*)malloc(stringLength+1 * sizeof(char));
        
        for (int j = 0; j < stringLength; j++) {
            lengthUFT8String[j] = jsonUFT8String[j+i];
        }
        
        lengthUFT8String[stringLength] = '\0';

        NSInteger jsonLength = [[NSString stringWithUTF8String:lengthUFT8String] integerValue];
        free(lengthUFT8String);
        
        char* jsonUTF8SubString = malloc(jsonLength + 1 * sizeof(char));
        
        for (int j = 0; j < jsonLength; j++) {
            jsonUTF8SubString[j] = jsonUFT8String[j+i+1+stringLength];
        }
        jsonUTF8SubString[jsonLength] = '\0';
        BCTFrame* frame = [BCTFrame frameWithJSONString:[NSString stringWithUTF8String:jsonUTF8SubString]];
        
        free(jsonUTF8SubString);
        
        [frames addObject:frame];
        
        i += stringLength + jsonLength;

    }
    return frames;
}

+ (instancetype)frameWithJSONString:(NSString*)json {

    NSData* jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError* err = nil;
    NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&err];
    
    
    if (err) {
        NSLog(@"[FAILED] parse json with err: %@", err);
        BCTFrame* frame = [BCTFrame frameWithError:[err description]];
        return frame;
    }
    
    NSNumber* success = [jsonDic valueForKey:@"success"];
    if (success && ![success boolValue]) {
        NSString* errorMessage = [jsonDic valueForKey:@"error"];
        NSLog(@"[NOTICED] bad request: %@", errorMessage);
        BCTFrame* frame = [BCTFrame frameWithError:errorMessage];
        return frame;
        
    }
    
    BCTFrame* frame = [[BCTFrame alloc] init];
    [frame setValuesForKeysWithDictionary:jsonDic];
    return frame;
}

- (instancetype)initWithType:(BCTFrameType)type token:(NSString*)token data:(id)data version:(int)version {
    if (self = [super init]) {
        _type = type;
        _token = token;
        _data = data;
        _version = version;
    }
    return self;
}

#pragma mark output frame

+ (instancetype)frameWithError:(NSString*)error {
    return [[BCTFrame alloc] initWithType:BCTFrameTypeError token:@"" data:error version:KBCTFrameVersion];
}

+ (instancetype)identificationFrameWithPhoneNumber:(NSString*)phoneNumber {
    return [[BCTFrame alloc] initWithType:BCTFrameTypeIdentification token:kBCTFrameToken data:[NSString stringWithFormat:@"{\"phoneNumber\":\"%@\"}", phoneNumber] version:KBCTFrameVersion];
}

// input 和 output 的时候frame的data数据类型不一样， 分别是 NSDictionary* 和 NSString*
+ (instancetype)messageFrameWithMessage:(NSString*)message {
    return [[BCTFrame alloc] initWithType:BCTFrameTypePeerMessage token:@"" data:message version:KBCTFrameVersion];
}



- (NSData*)frameData {
    NSString* jsonString = [NSString stringWithFormat:@"{\"type\":%lu,\"token\":\"%@\",\"data\":%@,\"version\":%d}",(unsigned long)self.type,self.token,self.data,self.version];
    NSString* frameJSON = [NSString stringWithFormat:@"%ld#%@", jsonString.length, jsonString];
    if (kBCTDebugMode) {
        NSLog(@"[SUCCEED] BCTFrame created: %@", frameJSON);
    }
    return [frameJSON dataUsingEncoding:NSUTF8StringEncoding];
}

@end
