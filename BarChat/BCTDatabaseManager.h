//
//  BCTDatabaseManager.h
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCTDatabaseManager : NSObject

- (BOOL)setupForPhoneNumber:(NSString*)phoneNumber;
- (BOOL)openDatabase:(NSString*)name;
- (BOOL)closeDatabase;
- (BOOL)executeSQL:(NSString*)sql params:(NSArray*)params;

@end
