//
//  NSObject+SHMDatabase.m
//  SHMDatabase
//
//  Created by teason23 on 2018/10/25.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "NSObject+SHMDatabase.h"
#import "SHMDatabaseSDK.h"
#import "SHMDBConst.h"
#import "SHMDbTools.h"
#import <YYModel/YYModel.h>
#import <objc/runtime.h>

NSString *const kPkid = @"pkid" ;

@implementation NSObject (SHMDatabase)

#pragma mark - props

static void *key_pkid = &key_pkid;
- (void)setPkid:(int)pkid {
    objc_setAssociatedObject(self, &key_pkid, @(pkid), OBJC_ASSOCIATION_ASSIGN);
}
- (int)pkid {
    return [objc_getAssociatedObject(self, &key_pkid) intValue];
}
static void *key_createtime = &key_createtime;
- (void)setShmdb_createTime:(long long)shmdb_createTime {
    objc_setAssociatedObject(self, &key_createtime, @(shmdb_createTime), OBJC_ASSOCIATION_ASSIGN);
}
- (long long)shmdb_createTime {
    return [objc_getAssociatedObject(self, &key_createtime) longLongValue];
}

static void *key_updatetime = &key_updatetime;
- (void)setShmdb_updateTime:(long long)shmdb_updateTime {
    objc_setAssociatedObject(self, &key_updatetime, @(shmdb_updateTime), OBJC_ASSOCIATION_ASSIGN);
}
- (long long)shmdb_updateTime {
    return [objc_getAssociatedObject(self, &key_updatetime) longLongValue];
}

static void *key_isdel = &key_isdel;
- (void)setShmdb_isDel:(BOOL)shmdb_isDel {
    objc_setAssociatedObject(self, &key_isdel, @(shmdb_isDel), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)shmdb_isDel {
    return [objc_getAssociatedObject(self, &key_isdel) boolValue];
}

#pragma mark--
#pragma mark - create

+ (BOOL)shmdb_tableIsExist {
    NSString *tableName = NSStringFromClass([self class]);
    return [[SHMDatabaseSDK sharedInstance] isTableExist:tableName];
}

+ (BOOL)shmdb_autoCreateIfNotExist {
    BOOL isExist = [self shmdb_tableIsExist];
    if (!isExist) {
        [self.class shmdb_createTable];
    }
    return isExist;
}

+ (BOOL)shmdb_createTable {
    NSString *tableName = NSStringFromClass([self class]);
    if (![[SHMDatabaseSDK sharedInstance] verify])
        return FALSE;
    
    __block BOOL bReturn = FALSE;
    if (![[SHMDatabaseSDK sharedInstance] isTableExist:tableName]) {
        [QUEUE inDatabase:^(FMDatabase *db) {
            // create table
            NSString *sql = [sqlUTIL sqlCreateTableWithClass:[self class]];
            bReturn       = [db executeUpdate:sql];
            if (bReturn) {
                SHMDBLog(@"shmdb_db create %@ success", tableName);
            }
            else {
                SHMDBLog(@"shmdb_db create %@ fail", tableName);
            }
        }];
    }
    
    return bReturn;
}

#pragma mark--
#pragma mark - insert

typedef NS_ENUM(NSUInteger, XTFMDB_insertWay) {
    shmdb_insertWay_insert,
    shmdb_insertWay_insertOrIgnore,
    shmdb_insertWay_insertOrReplace
};

- (BOOL)insertByWay:(XTFMDB_insertWay)way {
    if (![[SHMDatabaseSDK sharedInstance] verify])
        return -1;
    [self.class shmdb_autoCreateIfNotExist];
    
    __block BOOL bSuccess;
    [QUEUE inDatabase:^(FMDatabase *db) {
        [self setValue:@([NSDate shmdb_getNowTick]) forKey:@"shmdb_createTime"];
        [self setValue:@([NSDate shmdb_getNowTick]) forKey:@"shmdb_updateTime"];
        
        switch (way) {
            case shmdb_insertWay_insert:
                bSuccess = [db executeUpdate:[sqlUTIL sqlInsertWithModel:self]];
                break;
            case shmdb_insertWay_insertOrIgnore:
                bSuccess = [db executeUpdate:[sqlUTIL sqlInsertOrIgnoreWithModel:self]];
                break;
            case shmdb_insertWay_insertOrReplace:
                bSuccess = [db executeUpdate:[sqlUTIL sqlInsertOrReplaceWithModel:self]];
                break;
            default:
                break;
        }
    }];
    
    return bSuccess;
}

+ (BOOL)insertList:(NSArray *)modelList byWay:(XTFMDB_insertWay)way {
    if (!modelList || !modelList.count)
        return FALSE;
    if (![[SHMDatabaseSDK sharedInstance] verify])
        return FALSE;
    [[[modelList firstObject] class] shmdb_autoCreateIfNotExist];
    
    __block BOOL bAllSuccess = TRUE;
    [QUEUE inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (int i = 0; i < [modelList count]; i++) {
            id model = [modelList objectAtIndex:i];
            [model setValue:@([NSDate shmdb_getNowTick]) forKey:@"shmdb_createTime"];
            [model setValue:@([NSDate shmdb_getNowTick]) forKey:@"shmdb_updateTime"];
            
            BOOL bSuccess;
            switch (way) {
                case shmdb_insertWay_insert:
                    bSuccess = [db executeUpdate:[sqlUTIL sqlInsertWithModel:model]];
                    break;
                case shmdb_insertWay_insertOrIgnore:
                    bSuccess =
                    [db executeUpdate:[sqlUTIL sqlInsertOrIgnoreWithModel:model]];
                    break;
                case shmdb_insertWay_insertOrReplace:
                    bSuccess =
                    [db executeUpdate:[sqlUTIL sqlInsertOrReplaceWithModel:model]];
                    break;
                default:
                    break;
            }
            
            if (bSuccess) {
                SHMDBLog(@"shmdb_db transaction insert Successfrom index :%d", i);
            }
            else { // error
                SHMDBLog(@"shmdb_db transaction insert Failure from index :%d", i);
                *rollback   = TRUE;
                bAllSuccess = FALSE;
                break;
            }
        }
        
        if (bAllSuccess) {
            SHMDBLog(@"shmdb_db transaction insert %@ all complete\n\n",
                      NSStringFromClass([self class]));
        }
        else {
            SHMDBLog(@"shmdb_db transaction insert %@ all fail\n\n",
                      NSStringFromClass([self class]));
        }
        
    }];
    
    return bAllSuccess;
}

- (BOOL)shmdb_insert {
    return [self insertByWay:shmdb_insertWay_insert];
}

+ (BOOL)shmdb_insertList:(NSArray *)modelList {
    return [self insertList:modelList byWay:shmdb_insertWay_insert];
}

- (BOOL)shmdb_insertOrIgnore {
    return [self insertByWay:shmdb_insertWay_insertOrIgnore];
}

+ (BOOL)shmdb_insertOrIgnoreWithList:(NSArray *)modelList {
    return [self insertList:modelList byWay:shmdb_insertWay_insertOrIgnore];
}

- (BOOL)shmdb_insertOrReplace {
    return [self insertByWay:shmdb_insertWay_insertOrReplace];
}

+ (BOOL)shmdb_insertOrReplaceWithList:(NSArray *)modelList {
    return [self insertList:modelList byWay:shmdb_insertWay_insertOrReplace];
}

- (BOOL)shmdb_upsertWhereByProp:(NSString *)propName {
    BOOL exist = [[self class]
                  shmdb_hasModelWhere:[NSString stringWithFormat:@"%@ == '%@'", propName, [self valueForKey:propName]]];
    if (exist) {
        return [self shmdb_updateWhereByProp:propName];
    }
    else {
        return [self shmdb_insert];
    }
}

#pragma mark--
#pragma mark - update

/**
 Update
 default update by pkid.
 if pkid nil, update by a unique prop if has .
 */
- (BOOL)shmdb_update {
    if (self.pkid != 0) {
        return [self shmdb_updateWhereByProp:kPkid];
    }
    else {
        NSDictionary *keywordsMap     = [self.class modelPropertiesSqliteKeywords];
        NSString *    getOneUniqueKey = nil;
        for (NSString *key in keywordsMap.allKeys) {
            NSString *val = keywordsMap[key];
            if ([val isEqualToString:@"UNIQUE"] || [val isEqualToString:@"unique"]) {
                getOneUniqueKey = key;
                break;
            }
        }
        
        if (getOneUniqueKey != nil) {
            return [self shmdb_updateWhereByProp:getOneUniqueKey];
        }
        else {
            SHMDBLog(@"shmdb_db update Failed from tb %@ \n no primary key\n",
                      NSStringFromClass([self class]));
            return NO;
        }
    }
    return NO;
}

+ (BOOL)shmdb_updateListByPkid:(NSArray *)modelList {
    return [self shmdb_updateList:modelList whereByProp:kPkid];
}

// update by custom key .
- (BOOL)shmdb_updateWhereByProp:(NSString *)propName {
    NSString *tableName = NSStringFromClass([self class]);
    if (![[SHMDatabaseSDK sharedInstance] verify])
        return FALSE;
    [self.class shmdb_autoCreateIfNotExist];
    
    __block BOOL bSuccess;
    [QUEUE inDatabase:^(FMDatabase *db) {
        [self setValue:@([NSDate shmdb_getNowTick]) forKey:@"shmdb_updateTime"];
        bSuccess = [db executeUpdate:[sqlUTIL sqlUpdateSetWhereWithModel:self
                                                                 whereBy:propName]];
        if (bSuccess) {
            SHMDBLog(@"shmdb_db update success from tb %@ \n\n", tableName);
        }
        else {
            SHMDBLog(@"shmdb_db update fail from tb %@ \n\n", tableName);
        }
    }];
    
    return bSuccess;
}

+ (BOOL)shmdb_updateList:(NSArray *)modelList whereByProp:(NSString *)propName {
    if (!modelList || !modelList.count)
        return FALSE;
    if (![[SHMDatabaseSDK sharedInstance] verify])
        return FALSE;
    [[[modelList firstObject] class] shmdb_autoCreateIfNotExist];
    
    __block BOOL bAllSuccess = TRUE;
    [QUEUE inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (int i = 0; i < [modelList count]; i++) {
            id model = [modelList objectAtIndex:i];
            [model setValue:@([NSDate shmdb_getNowTick]) forKey:@"shmdb_updateTime"];
            BOOL bSuccess =
            [db executeUpdate:[sqlUTIL sqlUpdateSetWhereWithModel:model
                                                          whereBy:propName]];
            if (bSuccess) {
                SHMDBLog(@"shmdb_db transaction update Successfrom index :%d", i);
            }
            else {
                SHMDBLog(@"shmdb_db transaction update Failure from index :%d", i);
                *rollback   = TRUE;
                bAllSuccess = FALSE;
                break;
            }
        }
        
        if (bAllSuccess) {
            SHMDBLog(@"shmdb_db transaction update all complete \n\n");
        }
        else {
            SHMDBLog(@"shmdb_db transaction update all fail \n\n");
        }
    }];
    
    return bAllSuccess;
}

#pragma mark--
#pragma mark - select

+ (NSArray *)shmdb_selectAll {
    return [self shmdb_findAll];
}

+ (NSArray *)shmdb_findAll {
    return [self shmdb_findWhere:nil];
}

+ (instancetype)shmdb_findFirstWhere:(NSString *)strWhere {
    return [[self shmdb_findWhere:strWhere] firstObject];
}

+ (instancetype)shmdb_findFirst {
    return [[self shmdb_findAll] firstObject];
}

+ (BOOL)shmdb_hasModelWhere:(NSString *)strWhere {
    return [self shmdb_findFirstWhere:strWhere] != nil;
}

+ (NSArray *)shmdb_selectWhere:(NSString *)strWhere {
    return [self shmdb_findWhere:strWhere];
}

+ (NSArray *)shmdb_findWhere:(NSString *)strWhere {
    NSString *tableName = NSStringFromClass([self class]);
    NSString *sql =
    !strWhere ? [NSString stringWithFormat:@"SELECT * FROM %@", tableName] : [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",
                                                                              tableName,
                                                                              strWhere];
    return [self shmdb_findWithSql:sql];
}

// any sql
+ (NSArray *)shmdb_findWithSql:(NSString *)sql {
    if (![[SHMDatabaseSDK sharedInstance] verify])
        return nil;
    [self.class shmdb_autoCreateIfNotExist];
    
    __block NSMutableArray *resultList = [@[] mutableCopy];
    [QUEUE inDatabase:^(FMDatabase *db) {
        SHMDBLog(@"sql :\n %@", sql);
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *rstDic =
            [sqlUTIL getResultDicFromClass:[self class] resultSet:rs];
            id resultItem = [[self class] yy_modelWithJSON:rstDic];
            resultItem =
            [sqlUTIL resetDictionaryFromDBModel:rstDic resultItem:resultItem];
            [resultList addObject:resultItem];
        }
        [rs close];
    }];
    
    return resultList;
}

+ (instancetype)shmdb_findFirstWithSql:(NSString *)sql {
    return [[self shmdb_findWithSql:sql] firstObject];
}

+ (id)shmdb_anyFuncWithSql:(NSString *)sql {
    __block id val;
    [QUEUE inDatabase:^(FMDatabase *db) {
        SHMDBLog(@"sql :\n %@", sql);
        [db executeStatements:sql
              withResultBlock:^int(NSDictionary *resultsDictionary) {
                  val = [resultsDictionary.allValues lastObject];
                  return 0;
              }];
    }];
    return !((NSNull *)val == [NSNull null]) ? val : nil;
}

+ (BOOL)shmdb_isEmptyTable {
    return ![self shmdb_count];
}

+ (int)shmdb_count {
    return [self shmdb_countWhere:nil];
}

+ (int)shmdb_countWhere:(NSString *)whereStr {
    whereStr = whereStr ? [NSString stringWithFormat:@"WHERE %@", whereStr] : @"";
    return [[self
             shmdb_anyFuncWithSql:[NSString
                                stringWithFormat:@"SELECT count(*) FROM %@ %@",
                                NSStringFromClass([self class]),
                                whereStr]] intValue];
}

+ (double)shmdb_maxOf:(NSString *)property {
    return [self shmdb_maxOf:property where:nil];
}

+ (double)shmdb_maxOf:(NSString *)property where:(NSString *)whereStr {
    whereStr = whereStr ? [NSString stringWithFormat:@"WHERE %@", whereStr] : @"";
    return [[self
             shmdb_anyFuncWithSql:[NSString stringWithFormat:@"SELECT max(%@) FROM %@ %@",
                                property,
                                NSStringFromClass(
                                                  [self class]),
                                whereStr]] doubleValue];
}

+ (double)shmdb_minOf:(NSString *)property {
    return [self shmdb_minOf:property where:nil];
}

+ (double)shmdb_minOf:(NSString *)property where:(NSString *)whereStr {
    whereStr = whereStr ? [NSString stringWithFormat:@"WHERE %@", whereStr] : @"";
    return [[self
             shmdb_anyFuncWithSql:[NSString stringWithFormat:@"SELECT min(%@) FROM %@ %@",
                                property,
                                NSStringFromClass(
                                                  [self class]),
                                whereStr]] doubleValue];
}

+ (double)shmdb_sumOf:(NSString *)property {
    return [self shmdb_sumOf:property where:nil];
}

+ (double)shmdb_sumOf:(NSString *)property where:(NSString *)whereStr {
    whereStr = whereStr ? [NSString stringWithFormat:@"WHERE %@", whereStr] : @"";
    return [[self
             shmdb_anyFuncWithSql:[NSString stringWithFormat:@"SELECT sum(%@) FROM %@ %@",
                                property,
                                NSStringFromClass(
                                                  [self class]),
                                whereStr]] doubleValue];
}

+ (double)shmdb_avgOf:(NSString *)property {
    return [self shmdb_avgOf:property where:nil];
}

+ (double)shmdb_avgOf:(NSString *)property where:(NSString *)whereStr {
    whereStr = whereStr ? [NSString stringWithFormat:@"WHERE %@", whereStr] : @"";
    return [[self
             shmdb_anyFuncWithSql:[NSString stringWithFormat:@"SELECT avg(%@) FROM %@ %@",
                                property,
                                NSStringFromClass(
                                                  [self class]),
                                whereStr]] doubleValue];
}

#pragma mark--
#pragma mark - delete

- (BOOL)shmdb_deleteModel {
    return [[self class]
            shmdb_deleteModelWhere:[NSString stringWithFormat:@"pkid = '%lu'",
                                 (unsigned long)self.pkid]];
}

+ (BOOL)shmdb_deleteModelWhere:(NSString *)strWhere {
    NSString *tableName = NSStringFromClass([self class]);
    if (![[SHMDatabaseSDK sharedInstance] verify])
        return FALSE;
    [self.class shmdb_autoCreateIfNotExist];
    
    __block BOOL bSuccess = FALSE;
    [QUEUE inDatabase:^(FMDatabase *db) {
        bSuccess = [db executeUpdate:[sqlUTIL sqlDeleteWithTableName:tableName
                                                               where:strWhere]];
        if (bSuccess) {
            SHMDBLog(@"shmdb_db delete model success in %@\n\n", tableName);
        }
        else {
            SHMDBLog(@"shmdb_db delete model fail in %@\n\n", tableName);
        }
    }];
    
    return bSuccess;
}

+ (BOOL)shmdb_dropTable {
    NSString *tableName = NSStringFromClass([self class]);
    if (![[SHMDatabaseSDK sharedInstance] verify])
        return FALSE;
    [self.class shmdb_autoCreateIfNotExist];
    
    __block BOOL bSuccess = FALSE;
    [QUEUE inDatabase:^(FMDatabase *db) {
        bSuccess = [db executeUpdate:[sqlUTIL sqlDrop:tableName]];
        if (bSuccess) {
            SHMDBLog(@"shmdb_db drop %@ success\n\n", tableName);
        }
        else {
            SHMDBLog(@"shmdb_db drop %@ fail\n\n", tableName);
        }
    }];
    
    return bSuccess;
}

#pragma mark - alter

+ (BOOL)shmdb_alterAddColumn:(NSString *)name type:(NSString *)type {
    NSString *tableName = NSStringFromClass([self class]);
    if (![[SHMDatabaseSDK sharedInstance] verify])
        return FALSE;
    [self.class shmdb_autoCreateIfNotExist];
    
    __block BOOL bSuccess = FALSE;
    [QUEUE inDatabase:^(FMDatabase *db) {
        bSuccess =
        [db executeUpdate:[sqlUTIL sqlAlterAdd:name type:type table:tableName]];
        if (bSuccess) {
            SHMDBLog(@"shmdb_db alter add success in %@\n\n", tableName);
        }
        else {
            SHMDBLog(@"shmdb_db alter add fail in %@\n\n", tableName);
        }
    }];
    return bSuccess;
}

+ (BOOL)shmdb_alterRenameToNewTableName:(NSString *)name {
    NSString *tableName = NSStringFromClass([self class]);
    if (![[SHMDatabaseSDK sharedInstance] verify])
        return FALSE;
    [self.class shmdb_autoCreateIfNotExist];
    
    __block BOOL bSuccess = FALSE;
    [QUEUE inDatabase:^(FMDatabase *db) {
        bSuccess = [db executeUpdate:[sqlUTIL sqlAlterRenameOldTable:tableName
                                                      toNewTableName:name]];
        if (bSuccess) {
            SHMDBLog(@"shmdb_db alter rename success in %@\n\n", tableName);
        }
        else {
            SHMDBLog(@"shmdb_db alter rename fail in %@\n\n", tableName);
        }
    }];
    return bSuccess;
}

#pragma mark--
#pragma mark - rewrite in subClass if Needed .

// set constraints of properties
+ (NSDictionary *)modelPropertiesSqliteKeywords {
    return nil;
}

// ignore Properties
+ (NSArray *)ignoreProperties {
    return nil;
}

// Container property , value should be Class or Class name. Same as YYmodel .
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return nil;
}


@end
