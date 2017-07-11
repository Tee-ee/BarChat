//
//  BCTDateManager.m
//  BarChat
//
//  Created by Vince on 7/11/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTDateManager.h"

@implementation BCTDateManager

+ (instancetype)sharedManager {
    static dispatch_once_t pred;
    static BCTDateManager* manager = nil;
    
    dispatch_once(&pred, ^{
        manager = [[BCTDateManager alloc] init];
    });
    
    return manager;
}

- (NSTimeInterval)relativeTimeInterval {
    NSDate* date = [NSDate date];
    NSTimeInterval result = [date timeIntervalSince1970];
    return result;
}

- (NSString*)dateStringWithTimeIntervalSince1970:(NSTimeInterval)interval {
    NSString* dateString = @"_date_";
    NSDate* messageDate = [NSDate dateWithTimeIntervalSince1970:interval];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone systemTimeZone];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    if ([calendar isDateInToday:messageDate]) {
        formatter.dateFormat = @"hh:mm aa";
        dateString = [formatter stringFromDate:messageDate];
    }
    else if ([calendar isDateInYesterday:messageDate]) {
        dateString = @"昨天";
    }
    
    else {
        formatter.dateFormat = @"dd/MM/yy";
        dateString = [formatter stringFromDate:messageDate];
    }
    
    return dateString;
}


@end
