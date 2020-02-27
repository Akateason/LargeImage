//
//  SHMDbTools.h
//  SHMDatabase
//
//  Created by teason23 on 2018/10/25.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHMDbTools : NSObject

@end

@interface NSObject (SHMDbTools_Reflection)

- (NSString *)className;
+ (NSString *)className;

- (NSString *)superClassName;
+ (NSString *)superClassName;

- (NSDictionary *)propertyDictionary;

- (NSArray *)propertyKeys;
+ (NSArray *)propertyKeys;

- (NSArray *)propertiesInfo;
+ (NSArray *)propertiesInfo;
+ (NSDictionary *)propertiesInfoDict;
+ (NSString *)iosTypeWithPropName:(NSString *)name;

+ (NSArray *)propertiesWithCodeFormat;

- (NSArray *)methodList;
+ (NSArray *)methodList;

- (NSArray *)methodListInfo;

+ (NSArray *)registedClassList;

+ (NSArray *)instanceVariable;

- (NSDictionary *)protocolList;
+ (NSDictionary *)protocolList;

- (BOOL)hasPropertyForKey:(NSString *)key;
- (BOOL)hasIvarForKey:(NSString *)key;

+ (NSString *)decodeType:(const char *)cString;

@end






static NSString *const kTIME_STR_FORMAT_1 = @"YYYYMMddHHmmss";
static NSString *const kTIME_STR_FORMAT_2 = @"yyyy年MM月dd日";
static NSString *const kTIME_STR_FORMAT_3 = @"yyyy 年 MM 月 dd 日";
static NSString *const kTIME_STR_FORMAT_4 = @"YYYY-MM-dd HH:mm:ss";
static NSString *const kTIME_STR_FORMAT_5 = @"YYYY-MM-dd HH:mm";
static NSString *const kTIME_STR_FORMAT_6 = @"YYYY-MM-dd";
static NSString *const kTIME_STR_FORMAT_7 = @"MM-dd HH:mm";
static NSString *const kTIME_STR_FORMAT_8 = @"MM-dd";
static const float     kMillisecond       = 1000.0;
static const float     kSecond            = 1.0;
#define kUnitConversion kSecond

@interface NSDate (SHMDbTools_Tick)

/**
 get Tick
 */
+ (long long)shmdb_getNowTick;
- (long long)shmdb_getTick;
+ (long long)shmdb_getTickWithDateStr:(NSString *)dateStr
                            format:(NSString *)format;

/**
 compare tick
 */
+ (NSComparisonResult)shmdb_compareTick:(long long)tick1 and:(long long)tick2;

/**
 get time str
 @p fomat default is kTIME_STR_FORMAT_1
 */
+ (NSString *)shmdb_getStrWithTick:(long long)tick;
+ (NSString *)shmdb_getStrWithTick:(long long)tick format:(NSString *)format;
- (NSString *)shmdb_getStr;
- (NSString *)shmdb_getStrWithFormat:(NSString *)format;
- (NSString *)shmdb_timeInfo;
- (NSString *)shmdb_getMMDD;

/**
 get date
 @p fomat default is kTIME_STR_FORMAT_1
 */
+ (NSDate *)shmdb_getDateWithTick:(long long)tick;
+ (NSDate *)shmdb_getDateWithStr:(NSString *)dateStr;
+ (NSDate *)shmdb_getDateWithStr:(NSString *)dateStr format:(NSString *)format;

@end






NS_ASSUME_NONNULL_END
