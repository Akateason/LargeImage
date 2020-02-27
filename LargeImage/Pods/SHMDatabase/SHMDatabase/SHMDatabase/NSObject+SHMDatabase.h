//
//  NSObject+SHMDatabase.h
//  SHMDatabase
//
//  Created by teason23 on 2018/10/25.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kPkid ;

@interface NSObject (SHMDatabase)
// Default columns
@property (nonatomic) int       pkid; // primaryKey
@property (nonatomic) long long shmdb_createTime;
@property (nonatomic) long long shmdb_updateTime;
@property (nonatomic) BOOL      shmdb_isDel;

#pragma mark - create

+ (BOOL)shmdb_tableIsExist;
+ (BOOL)shmdb_autoCreateIfNotExist;
+ (BOOL)shmdb_createTable;

#pragma mark - insert

// insert
- (BOOL)shmdb_insert;
+ (BOOL)shmdb_insertList:(NSArray *)modelList;

// insert or ignore
- (BOOL)shmdb_insertOrIgnore;
+ (BOOL)shmdb_insertOrIgnoreWithList:(NSArray *)modelList;

// insert or replace
- (BOOL)shmdb_insertOrReplace;
+ (BOOL)shmdb_insertOrReplaceWithList:(NSArray *)modelList;

// upsert
- (BOOL)shmdb_upsertWhereByProp:(NSString *)propName;

#pragma mark - update

// update by pkid .
- (BOOL)shmdb_update; // Update default update by pkid. if pkid nil, update by a
// unique prop if has .
+ (BOOL)shmdb_updateListByPkid:(NSArray *)modelList;

// update by custom key .
- (BOOL)shmdb_updateWhereByProp:(NSString *)propName;
+ (BOOL)shmdb_updateList:(NSArray *)modelList whereByProp:(NSString *)propName;

#pragma mark - select

+ (NSArray *)shmdb_findAll;
+ (NSArray *)shmdb_findWhere:(NSString *)strWhere; // param e.g. @" pkid = '1' "

+ (instancetype)shmdb_findFirstWhere:(NSString *)strWhere;
+ (instancetype)shmdb_findFirst;
+ (BOOL)shmdb_hasModelWhere:(NSString *)strWhere;

// any sql execute Query
+ (NSArray *)shmdb_findWithSql:(NSString *)sql;
+ (instancetype)shmdb_findFirstWithSql:(NSString *)sql;

// func execute Statements
+ (id)shmdb_anyFuncWithSql:(NSString *)sql;
+ (BOOL)shmdb_isEmptyTable;
+ (int)shmdb_count;
+ (int)shmdb_countWhere:(NSString *)whereStr;
+ (double)shmdb_maxOf:(NSString *)property;
+ (double)shmdb_maxOf:(NSString *)property where:(NSString *)whereStr;
+ (double)shmdb_minOf:(NSString *)property;
+ (double)shmdb_minOf:(NSString *)property where:(NSString *)whereStr;
+ (double)shmdb_sumOf:(NSString *)property;
+ (double)shmdb_sumOf:(NSString *)property where:(NSString *)whereStr;
+ (double)shmdb_avgOf:(NSString *)property;
+ (double)shmdb_avgOf:(NSString *)property where:(NSString *)whereStr;

#pragma mark - delete

- (BOOL)shmdb_deleteModel;
+ (BOOL)shmdb_deleteModelWhere:(NSString *)strWhere; // param e.g. @" pkid = '1' "
+ (BOOL)shmdb_dropTable;

#pragma mark - alter

/**
 use [[XTFMDBBase sharedInstance] dbUpgradeTable: paramsAdd: version:] to
 upgrade Database !!!
 */
+ (BOOL)shmdb_alterAddColumn:(NSString *)name type:(NSString *)type;
+ (BOOL)shmdb_alterRenameToNewTableName:(NSString *)name;

#pragma mark - Constraints config

// props Sqlite Keywords
+ (NSDictionary *)modelPropertiesSqliteKeywords; // set sqlite Constraints of property
// ignore Properties . these properties will not join db CURD .
+ (NSArray *)ignoreProperties;
// Container property , value should be Class or Class name. Same as YYmodel .
+ (NSDictionary *)modelContainerPropertyGenericClass;

@end

