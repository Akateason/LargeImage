//
//  SHMDatabaseSDK.m
//  SHMDatabase
//
//  Created by teason23 on 2018/10/25.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "SHMDatabaseSDK.h"
#import "NSObject+SHMDatabase.h"
#import "SHMDbTools.h"
#import "SHMDBVersion.h"
#import "SHMDBConst.h"

#define SQLITE_NAME(_name_) [_name_ stringByAppendingString:@".sqlite"]

@interface SHMDatabaseSDK ()
@property (nonatomic, strong, readwrite) FMDatabase *database;
@end

@implementation SHMDatabaseSDK
@synthesize     version = _version;

+ (SHMDatabaseSDK *)sharedInstance {
    static dispatch_once_t onceToken;
    static SHMDatabaseSDK *    singleton;
    dispatch_once(&onceToken, ^{
        singleton = [[SHMDatabaseSDK alloc] init];
    });
    return singleton;
}

- (int)version {
    return [SHMDBVersion shmdb_findFirst].version;
}

- (void)setVersion:(int)version {
    SHMDBVersion *dbv = [SHMDBVersion shmdb_findFirst];
    dbv.version      = version;
    [dbv shmdb_update];
    _version = version;
}

#pragma mark--
#pragma mark - configure

- (void)configureDBWithPath:(NSString *)finalPath {
    finalPath = SQLITE_NAME(finalPath);
    SHMDBLog(@"shmdb_db path :\n%@", finalPath);
    DB = [FMDatabase databaseWithPath:finalPath];
    [DB open];
    
    QUEUE = [FMDatabaseQueue databaseQueueWithPath:finalPath];
    
    sqlUTIL = [[SHMAutoSqlUtil alloc] init];
    
    [SHMDBVersion shmdb_createTable];
    
    if (!self.version) {
        SHMDBVersion *dbv = [SHMDBVersion new];
        dbv.version      = 1;
        [dbv shmdb_insert];
    }
}

#pragma mark--

- (BOOL)verify {
    if (!DB) {
        SHMDBLog(@"shmdb_db not exist");
        return FALSE;
    }
    if (![DB open]) {
        SHMDBLog(@"shmdb_db open failed");
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL)isTableExist:(NSString *)tableName {
    __block BOOL bExist;
    [QUEUE inDatabase:^(FMDatabase *db) {
        bExist = [db tableExists:tableName];
        if (!bExist) {
            SHMDBLog(@"shmdb_db %@ table not created", tableName);
        }
    }];
    return bExist;
}

#pragma mark--

- (void)dbUpgradeTable:(Class)tableCls
             paramsAdd:(NSArray *)paramsAdd
               version:(int)version {
    NSString *tableName = NSStringFromClass(tableCls);
    int       dbVersion = self.version;
    if (version <= dbVersion) {
        SHMDBLog(@"shmdb_db already Upgraded. v%d for table %@", version, tableName);
        return;
    }
    if (![self isTableExist:tableName]) {
        return;
    }
    
    SHMDBLog(
              @"shmdb_db upgrade start \ntable : %@ \nparamsAdd : %@\ndbversion : %d",
              tableName,
              paramsAdd,
              version);
    
    __block BOOL isError = NO;
    [paramsAdd enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *iosType = [tableCls iosTypeWithPropName:key];
        NSString *sqlType = [sqlUTIL sqlTypeWithType:iosType];
        if (!iosType) {
            SHMDBLog(@"shmdb_db Upgraded fail no prop in %@", tableName);
            isError = YES;
            *stop   = YES;
        }
        if (!isError) {
            [tableCls performSelector:@selector(shmdb_alterAddColumn:type:)
                           withObject:key
                           withObject:sqlType];
        }
    }];
    if (isError)
        return;
    
    self.version = version;
    SHMDBLog(@"shmdb_db Upgraded v%d complete", version);
}

@end
