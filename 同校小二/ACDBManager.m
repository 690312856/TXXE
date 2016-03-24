//
//  ACDBManager.m
//  TXXE
//
//  Created by River on 15/6/8.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "ACDBManager.h"
#import "Constants.h"
#import "NSString+Addition.h"

@interface ACDBManager ()

@property (nonatomic , strong) FMDatabaseQueue *database;
@property (nonatomic , copy) NSString *databasePath;

@end
@implementation ACDBManager

+ (instancetype)sharedInstance
{
    static ACDBManager *manager_ptr = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager_ptr = [[self alloc] init];
        [manager_ptr copyDatabaseToDocument];
    });
    return manager_ptr;
}

- (void)copyDatabaseToDocument
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *upperLevelRoot = [self.databasePath stringByDeletingLastPathComponent];
    
    if (![fileManager fileExistsAtPath:upperLevelRoot]) {
        NSError *createPathError = nil;
        [fileManager createDirectoryAtPath:upperLevelRoot withIntermediateDirectories:YES attributes:nil error:&createPathError];
        if (createPathError) {
            NSLog(@"createPathError = %@",createPathError);
        }
    }
    
    NSString *dbSource = [[NSBundle mainBundle] pathForResource:@"TXXE2" ofType:@"sqlite"];
    NSLog(@"%@",dbSource);
    if (![fileManager fileExistsAtPath:self.databasePath]) {
        NSError *copyError = nil;
        NSLog(@"%@",_databasePath);
        [fileManager copyItemAtPath:dbSource toPath:self.databasePath error:&copyError];
        if (copyError) {
            NSLog(@"copyError = %@",copyError);
        }
    }
}

- (NSString *)databasePath
{
    if (!_databasePath) {
        NSString *userIdentifier = [NSString stringWithFormat:@"TXXE2"];
        NSString *userDirectory = [PATH_OF_DOCUMENT stringByAppendingPathComponent:userIdentifier];
        _databasePath = [userDirectory stringByAppendingPathComponent:@"TXXE2.sqlite"];
    }
    NSLog(@"%@",_databasePath);
    return _databasePath;
}

- (FMDatabaseQueue *)database
{
    if (!_database) {
        _database = [FMDatabaseQueue databaseQueueWithPath:self.databasePath];
        NSLog(@"Is SQLite compiled with it's thread safe options turned on? %@!", [FMDatabase isSQLiteThreadSafe] ? @"Yes" : @"No");
    }
    return _database;
}

#pragma mark -
#pragma mark - 增、删、改、查

- (BOOL)insertIntoTable:(NSString *)table withAttribute:(NSDictionary *)attribute
{
    __block BOOL insertResult = NO;
    if ([attribute count] == 0) {
        return insertResult;
    } else {
        [self.database inDatabase:^(FMDatabase *db) {
            if ([db open]) {
                NSArray *allValues = [attribute allValues];
                NSMutableString *prefixBingString = [[NSMutableString alloc] init];
                NSMutableString *suffixBingString = [[NSMutableString alloc] init];
                
                [prefixBingString appendFormat:@"INSERT INTO %@ (",table];
                [suffixBingString appendString:@"VALUES ("];
                
                for (int i = 0; i != [[attribute allKeys] count]; ++ i) {
                    NSString *keyString = [[attribute allKeys] objectAtIndex:i];
                    [prefixBingString appendFormat:@"%@",keyString];
                    [suffixBingString appendString:@"?"];
                    
                    if (i != [[attribute allKeys] count] - 1) {
                        [prefixBingString appendString:@","];
                        [suffixBingString appendString:@","];
                    } else {
                        [prefixBingString appendString:@")"];
                        [suffixBingString appendString:@")"];
                    }
                }
                [prefixBingString appendString:suffixBingString];
                insertResult = [db executeUpdate:prefixBingString withArgumentsInArray:allValues];
                if (!insertResult) {
                    NSLog(@"%s,error:%@",__PRETTY_FUNCTION__,db.lastErrorMessage);
                }
                if (![db close]) {
                    NSLog(@"数据库关闭失败:%@",[db lastErrorMessage]);
                }
            }
        }];
    }
    return insertResult;
}

- (BOOL)deleteInTable:(NSString *)table withSQLCondition:(NSString *)condition
{
    __block BOOL deleteResult = NO;
    [self.database inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSMutableString *prefixString = [[NSMutableString alloc] init];
            [prefixString appendFormat:@"DELETE FROM %@ ",table];
            NSString *suffixString = [NSString realForString:condition];
            [prefixString appendString:suffixString];
            
            deleteResult = [db executeUpdate:prefixString];
            if (!deleteResult) {
                NSLog(@"%s,error:%@",__PRETTY_FUNCTION__,db.lastErrorMessage);
            }
        }
        if (![db close]) {
            NSLog(@"数据库关闭失败:%@",[db lastErrorMessage]);
        }
    }];
    return deleteResult;
}

- (BOOL)updateForTable:(NSString *)table withAttribute:(NSDictionary *)attribute withSQLCondition:(NSString *)condition
{
    __block BOOL updateResult = NO;
    [self.database inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSArray *allValues = [attribute allValues];
            NSMutableString *prefixBindString = [[NSMutableString alloc] init];
            [prefixBindString appendFormat:@"update %@ set ",table];
            
            for (int i = 0; i != [[attribute allKeys] count]; ++ i) {
                NSString *keyString = [[attribute allKeys] objectAtIndex:i];
                [prefixBindString appendFormat:@"%@=? ",keyString];
                if (i != [[attribute allKeys] count] - 1) {
                    [prefixBindString appendString:@","];
                } else {
                    [prefixBindString appendString:[NSString realForString:condition]];
                }
            }
            updateResult = [db executeUpdate:prefixBindString withArgumentsInArray:allValues];
            if (!updateResult) {
                NSLog(@"%s,error:%@",__PRETTY_FUNCTION__,db.lastErrorMessage);
            }
            if (![db close]) {
                NSLog(@"数据库关闭失败:%@",[db lastErrorMessage]);
            }
        }
    }];
    return updateResult;
}

- (NSArray *)queryTableWithCompletedFullSQLText:(NSString*)SQLText
{
    __block NSMutableArray *resultList = [NSMutableArray array];
    [self.database inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet *info = [db executeQuery:SQLText];
            while ([info next]) {
                [resultList addObject:[info resultDictionary]];
            }
            if (![db close]) {
                NSLog(@"数据库关闭失败:%@",[db lastErrorMessage]);
            }
        }
    }];
    return resultList;
}

- (NSArray *)queryTable:(NSString *)table withSQLCondition:(NSString *)condition
{
    __block NSMutableArray *resultList = [NSMutableArray array];
    [self.database inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ %@",table,[NSString realForString:condition]];
            FMResultSet *info = [db executeQuery:sqlString];
            while ([info next]) {
                [resultList addObject:[info resultDictionary]];
            }
            if (![db close]) {
                NSLog(@"数据库关闭失败:%@",[db lastErrorMessage]);
            }
        }
    }];
    return resultList;
}

- (NSInteger)getRecordCountForTable:(NSString *)table withSQLCondition:(NSString *)condition
{
    __block int count = 0;
    [self.database inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sqlString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ %@",table,[NSString realForString:condition]];
            count = [db intForQuery:sqlString];
            if (![db close]) {
                NSLog(@"数据库关闭失败:%@",[db lastErrorMessage]);
            }
        }
    }];
    return count;
}









@end
