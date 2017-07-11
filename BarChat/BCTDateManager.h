//
//  BCTDateManager.h
//  BarChat
//
//  Created by Vince on 7/11/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCTDateManager : NSObject

+ (instancetype)sharedManager;

- (NSTimeInterval)relativeTimeInterval;

- (NSString*)dateStringWithTimeIntervalSince1970:(NSTimeInterval)interval;
@end
