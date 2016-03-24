//
//  ACDBManager.h
//  TXXE
//
//  Created by River on 15/6/8.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface ACDBManager : NSObject

@property (nonatomic , copy,readonly) NSString *databasePath;
@property (nonatomic , strong, readonly) FMDatabaseQueue *database;

+ (instancetype)sharedInstance;
/**
 *  增加记录
 *
 *  @param table     要插入到的表
 *  @param attribute key-value字典
 *
 *  @return 如果插入成功，返回YES；否则，返回NO
 */
- (BOOL)insertIntoTable:(NSString *)table withAttribute:(NSDictionary *)attribute;

/**
 *  删除记录
 *
 *  @param table     要删除的表
 *  @param condition 删除条件，如果为空值，表示删除整个表
 *
 *  @return 删除成功返回YES;失败返回NO
 */
- (BOOL)deleteInTable:(NSString *)table withSQLCondition:(NSString *)condition;

/**
 *  更新数据
 *
 *  @param table     要被更新的表
 *  @param attribute key-value字典
 *  @param condition 更新时候的sql条件
 *
 *  @return 更新成功返回YES；更新失败返回NO
 */
- (BOOL)updateForTable:(NSString *)table withAttribute:(NSDictionary *)attribute  withSQLCondition:(NSString *)condition;

/**
 *  查询数据集
 *
 *  @param table 查询表
 *  @param sql   查询语句条件（仅仅只是SQL的条件部分）
 *
 *  @return 由key-value字典组成的数组
 */
- (NSArray *)queryTable:(NSString *)table withSQLCondition:(NSString*)condition;

/**
 *  查询数据集
 *
 *  @param table   查询表
 *  @param SQLText 查询语句（完整的SQL语句）
 *
 *  @return 有key-value字典组成的数组
 */
- (NSArray *)queryTableWithCompletedFullSQLText:(NSString*)SQLText;

/**
 *  查询记录个数
 *
 *  @param table     要被查询的表
 *  @param condition 查询条件
 *
 *  @return 满足条件的记录的条数
 */
- (NSInteger)getRecordCountForTable:(NSString *)table withSQLCondition:(NSString *)condition;


@end
