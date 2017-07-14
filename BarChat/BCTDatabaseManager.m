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

@interface BCTDatabaseManager()

@property (nonatomic, strong) NSString* currentUserPhoneNumber;

@end

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
    
    self.currentUserPhoneNumber = phoneNumber;
    NSString* databaseName = [NSString stringWithFormat:@"db%@", phoneNumber];
    if (![self openDatabase:databaseName]) {
        NSLog(@"[FAILED] setup database for phone number : %@", phoneNumber);
        return NO;
    }

    if (![self createTableWithName:@"friends" columns:@{@"phoneNumber":@"char(11) primary key", @"userName":@"varchar(20)", @"nickname":@"varchar(20)", @"gender":@"char(1)", @"photo":@"int"}]) {
        NSLog(@"[FAILED] setup database for phone number : %@", phoneNumber);
        return NO;
    }
    

    if (![self createTableWithName:@"conversations" columns:@{@"phoneNumber":@"char(11) primary key", @"displayName":@"varchar(20)", @"content":@"varchar(20)", @"messageType":@"tinyint", @"date":@"double"}]) {
        NSLog(@"[FAILED] setup database for phone number : %@", phoneNumber);
        return NO;
    }
    
    if (![self createTableWithName:@"images" columns:@{@"imageID":@"int primary key", @"imageData":@"blob"}]) {
        NSLog(@"[FAILED] setup database for phone number : %@", phoneNumber);
        return NO;
    }
    
    if (![self createTableWithName:@"friendRequests" columns:@{@"phoneNumber":@"char(11) primary key", @"userName":@"varchar(20)", @"requestMessage":@"varchar(40)", @"state":@"tinyint"}]) {
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

- (BOOL)executeSQL:(NSString*)sql {
    return [self executeSQL:sql params:nil];
}

- (BOOL)createTableWithName:(NSString*)tableName columns:(NSDictionary*)columns {
    __block NSString* sql = [NSString stringWithFormat:@"create table if not exists %@ (", tableName];
    [columns enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@ %@,", key, obj]];
    }];
    sql = [sql stringByReplacingCharactersInRange:NSMakeRange(sql.length-1, 1) withString:@")"];
    return [self executeSQL:sql];
}

- (BOOL)addFriendWithPhoneNumber:(NSString*)phoneNumber userName:(NSString*)userName gender:(NSString*)gender icon:(int)icon {
    if (![self createTableWithName:[NSString stringWithFormat:@"m%@", phoneNumber] columns:@{@"id":@"int primary key", @"content":@"varchar(255)", @"fromPhoneNumber":@"char(11)", @"toPhoneNumber":@"char(11)", @"date":@"double", @"type":@"tinyint", @"bubbleHeight":@"double"}]) {
        NSLog(@"[FAILED] create message history with :%@", phoneNumber);
        return NO;
    }
    
    NSLog(@"[SUCCEED] add friend into database: %@", phoneNumber);
    
    NSString* sql = [NSString stringWithFormat:@"insert into conversations (phoneNumber, displayName, content, messageType, date) values ('%@', '%@', '', -1, 0)", phoneNumber, userName];
    if (![self executeSQL:sql]) {
        NSLog(@"[FAILED] add conversation record with: %@", phoneNumber);
        return NO;
    }
    
    NSLog(@"[SUCCEED] add conversation record with: %@", phoneNumber);
    
    return YES;
}

- (BOOL)addMessageFrom:(NSString*)from to:(NSString*)to ID:(NSInteger)ID content:(NSString*)content date:(NSTimeInterval)date type:(NSUInteger)type toMe:(BOOL)toMe {
    NSString* friendPhoneNumber = toMe? from: to;
    NSString* sql = [NSString stringWithFormat:@"insert into m%@ (fromPhoneNumber, toPhoneNumber, id, content, date, type) values ('%@', '%@', %ld, '%@', %f, %ld)",friendPhoneNumber ,from, to, ID, content, date, type];
    if (![self executeSQL:sql]) {
        NSLog(@"[FAILED] add message into m%@", friendPhoneNumber);
        return NO;
    }
    NSLog(@"[SUCCEED] add message into m%@", friendPhoneNumber);
    
    sql = [NSString stringWithFormat:@"update conversations set content='%@', date='%f', messageType='%ld' where phoneNumber = '%@'", content, date, type, friendPhoneNumber];
    if (![self executeSQL:sql]) {
        NSLog(@"[FAILED] update conversation with: %@" ,friendPhoneNumber);
        return NO;
    }
    
    NSLog(@"[SUCCEED] update conversation with: %@" ,friendPhoneNumber);

    
    return YES;
}

- (NSArray*)queryConversations {
    __block NSMutableArray* result = [NSMutableArray array];
    
    [self queryDatabaseWithSQL:@"select * from conversations" block:^(sqlite3_stmt* statement){
        NSDictionary* conversation = @{@"phoneNumber":[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 4)], @"displayName":[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)], @"content": [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)], @"date": @(sqlite3_column_double(statement, 0)), @"type": @(sqlite3_column_int(statement, 3))};
        [result addObject:conversation];
    }];
    
    return result;
}

- (NSArray*)queryMessagesWithPhoneNumber:(NSString*)peerPhoneNumber {
    __block NSMutableArray* result = [NSMutableArray array];
    
    NSString* sql = [NSString stringWithFormat:@"select fromPhoneNumber,id,content,type,toPhoneNumber,date,bubbleHeight from m%@", peerPhoneNumber];
    
    [self queryDatabaseWithSQL:sql block:^(sqlite3_stmt* statement){
        NSDictionary* message = @{@"from":[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)], @"ID":@(sqlite3_column_int(statement, 1)), @"content":[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)], @"type":@(sqlite3_column_int(statement, 3)), @"to":[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 4)], @"date":@(sqlite3_column_double(statement, 5)), @"bubbleHeight":@(sqlite3_column_double(statement, 6))};
        [result addObject:message];
    }];
    
    return result;
}

- (void)queryDatabaseWithSQL:(NSString*)sql block:(void(^)(sqlite3_stmt*))block {
    if (!_database) {
        NSLog(@"[FAILED] trying to query sql: %@ when database is closed", sql);
        return;
    }
    
    sqlite3_stmt* statement;
    
    if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"[FAILED] prepare sql: %@", sql);
        return;
    }
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        block(statement);
    }
    
    sqlite3_finalize(statement);
    
    NSLog(@"[SUCCEED] query sql: %@", sql);
    
}

- (void)setBubbleHeight:(double)height forMessage:(NSInteger)ID friendPhoneNumber:(NSString*)phoneNumber {
    NSString* sql = [NSString stringWithFormat:@"update m%@ set bubbleHeight = %f where id = %ld", phoneNumber, height, ID];
    if(![self executeSQL:sql]) {
        NSLog(@"[FAILED] change bubble height for ID: %ld", ID);
        return;
    }
    
    NSLog(@"[SUCCEED] change bubble height for ID: %ld", ID);
    
}
@end

