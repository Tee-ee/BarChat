//
//  BCTDatabaseManager.m
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTDatabaseManager.h"
#import <sqlite3.h>
#import "BCTMacros.h"

@implementation BCTDatabaseManager
{
    sqlite3*    _database;
}
- (instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}


- (BOOL)setupForPhoneNumber:(NSString*)phoneNumber{
    NSString* databaseName = [NSString stringWithFormat:@"db%@", phoneNumber];
    if (![self openDatabase:databaseName]) {
        NSLog(@"[FAILED] setup database for phone number : %@", phoneNumber);
        return NO;
    }
    
    if (![self executeSQL:@"create table if not exists friends ( phoneNumber char(11) primary key, userName varchar(20), nickname varchar(20), gender char(1), photo int )" params:nil]) {
        NSLog(@"[FAILED] setup database for phone number : %@", phoneNumber);
        return NO;
    }
    
    if (![self executeSQL:@"create table if not exists conversations ( phoneNumber char(11) primary key, content varchar(20), displayName varchar(20), messageType tinyint, date int )" params:nil]) {
        NSLog(@"[FAILED] setup database for phone number : %@", phoneNumber);
        return NO;
    }
    
    if (![self executeSQL:@"create table if not exists images ( imageId int primary key, imageData blob)" params:nil]) {
        NSLog(@"[FAILED] setup database for phone number : %@", phoneNumber);
        return NO;
    }
    
    if (![self executeSQL:@"create table if not exists friendRequests ( phoneNumber char(11) primary key, userName varchar(20), requestMessage varchar(40), state tinyint )" params:nil]) {
        NSLog(@"[FAILED] setup database for phone number : %@", phoneNumber);
        return NO;
    }
    
    NSLog(@"[SUCCEED] setup database for phone number : %@", phoneNumber);
    return YES;
}

- (BOOL)openDatabase:(NSString*)name {
    if (_database) {
        NSLog(@"[NOTICE] database already open");
        return YES;
    }
    
    int databaseResult = sqlite3_open([kBCTPath(name) UTF8String], &_database);
    
    if (databaseResult != SQLITE_OK) {
        NSLog(@"[FAILED] opening/creating database : %@", name);
        return NO;
    }
    
    NSLog(@"[SUCCEED] opening/creating database : %@", name);
    return YES;
}

- (BOOL)closeDatabase {
    if (!_database) {
        NSLog(@"[NOTICE] databse already closed");
        return YES;
    }
    
    int databaseResult = sqlite3_close(_database);
    
    if (databaseResult != SQLITE_OK) {
        NSLog(@"[FAILED] closing database");
        return NO;
    }
    
    NSLog(@"[SUCCEED] closing database");
    return YES;
}

- (BOOL)executeSQL:(NSString*)sql params:(NSArray*)params {
    if (!_database) {
        NSLog(@"[FAILED] database closed when executing sql: %@ with params: %@", sql, params);
        return NO;
    }
    
    char* error = NULL;
    
    const char* SQLChar = [sql UTF8String];
    
    sqlite3_stmt* statement;
    
    if (sqlite3_prepare_v2(_database, SQLChar, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"[FAILED] prepare sql: %@ with params: %@", sql, params);
    }
    
    if (params) {
        for (int i = 0; i < params.count; i++) {
            NSString* param = [params objectAtIndex:i];
            const char* paramChar = [param UTF8String];
            
            if (!sqlite3_bind_text(statement, 1, paramChar, -1, SQLITE_STATIC)) {
                NSLog(@"[FAILED] bind sql: %@ with param: %@", sql, param);
            }
        }
    }
    
    int sqlResult = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (sqlResult != SQLITE_DONE) {
        NSLog(@"[FAILED] executing sql : %@ with params: %@ with error: %s", sql, params, error);
        return NO;
    }
    
    NSLog(@"[SUCCEED] executing sql: %@ with params: %@", sql, params);
    return YES;
}
@end

