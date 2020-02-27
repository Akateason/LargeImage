//
//  SHMDatabaseSDK.h
//  SHMDatabase
//
//  Created by teason23 on 2018/10/25.
//  Copyright © 2018年 teason23. All rights reserved.
//


#import <FMDB/FMDB.h>
#import <Foundation/Foundation.h>
#import "SHMAutoSqlUtil.h"

#define QUEUE           [SHMDatabaseSDK sharedInstance].queue
#define DB              [SHMDatabaseSDK sharedInstance].database
#define sqlUTIL         [SHMDatabaseSDK sharedInstance].sqlUtil
#define SHMDB_isDebug   [SHMDatabaseSDK sharedInstance].isDebugMode

NS_ASSUME_NONNULL_BEGIN

@interface SHMDatabaseSDK : NSObject

+ (SHMDatabaseSDK *)sharedInstance;

@property (nonatomic, strong, readonly) FMDatabase      *database;
@property (nonatomic, strong)           FMDatabaseQueue *queue;
@property (nonatomic)                   int             version;
@property (strong, nonatomic)           SHMAutoSqlUtil  *sqlUtil;
@property (nonatomic)                   BOOL            isDebugMode;

/**
 db prepare config db in - [(AppDelegate *) AppDidLaunchFinish]
 also create table of dbVersion .
 */
- (void)configureDBWithPath:(NSString *)finalPath;

/**
 DB Version Upgrade
 @param tableCls    Class
 @param paramsAdd   @[propName1 ,propName2 ,... ,]
 @param version (int) start from 1
 */
- (void)dbUpgradeTable:(Class)tableCls
             paramsAdd:(NSArray *)paramsAdd
               version:(int)version;

/**
 util
 */
- (BOOL)verify;
- (BOOL)isTableExist:(NSString *)tableName;

@end

NS_ASSUME_NONNULL_END
