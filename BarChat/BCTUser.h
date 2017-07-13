//
//  BCTUser.h
//  BarChat
//
//  Created by Vince on 7/11/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCTUser : NSObject

@property (nonatomic, strong, readonly) NSString*   userName;

@property (nonatomic, strong, readonly) NSString*   phoneNumber;

@property (nonatomic, strong) NSString*             nickName;

@property (nonatomic, strong, readonly) NSString*   gender;

@property (nonatomic, assign, readonly) int         photo;

+ (instancetype)userWithJSON:(NSDictionary*)json;

+ (instancetype)userWithUserName:(NSString*)userName phoneNumber:(NSString*)phoneNumber gender:(NSString*)gender photo:(int)photo;
@end
