//
//  NSArray+SHMDatabase.h
//  SHMDatabase
//
//  Created by teason23 on 2018/10/25.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (SHMDatabase)
/**
 Order by . (in memory)
 @param columnName  --- must be a int column
 @param descOrAsc   BOOL  desc - 1 , asc - 0
 @return a sorted list
 */
- (NSArray *)shmdb_orderby:(NSString *)columnName
              descOrAsc:(BOOL)descOrAsc;
@end

NS_ASSUME_NONNULL_END
