//
//  SHMAutoSqlUtil.h
//  SHMDatabase
//
//  Created by teason23 on 2018/10/25.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMResultSet;

NS_ASSUME_NONNULL_BEGIN

@interface SHMAutoSqlUtil : NSObject

- (NSString *)sqlCreateTableWithClass:(Class)cls;

- (NSString *)sqlInsertWithModel:(id)model;
- (NSString *)sqlInsertOrIgnoreWithModel:(id)model;
- (NSString *)sqlInsertOrReplaceWithModel:(id)model;

- (NSString *)sqlUpdateSetWhereWithModel:(id)model
                                 whereBy:(NSString *)whereProp;

- (NSString *)sqlDeleteWithTableName:(NSString *)tableName
                               where:(NSString *)strWhere;

- (NSString *)sqlDrop:(NSString *)tableName;

- (NSString *)sqlAlterAdd:(NSString *)name
                     type:(NSString *)type
                    table:(NSString *)tableName;

- (NSString *)sqlAlterRenameOldTable:(NSString *)oldTableName
                      toNewTableName:(NSString *)newTableName;

- (NSDictionary *)getResultDicFromClass:(Class)cls
                              resultSet:(FMResultSet *)resultSet;

- (NSString *)sqlTypeWithType:(NSString *)strType;

- (id)resetDictionaryFromDBModel:(NSDictionary *)dbModel resultItem:(id)item;

@end

NS_ASSUME_NONNULL_END
