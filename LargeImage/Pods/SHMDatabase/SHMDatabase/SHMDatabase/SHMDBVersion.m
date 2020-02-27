//
//  SHMDBVersion.m
//  SHMDatabase
//
//  Created by teason23 on 2018/10/25.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "SHMDBVersion.h"

@implementation SHMDBVersion
+ (NSDictionary *)modelPropertiesSqliteKeywords {
    return @{ @"version" : @"UNIQUE" };
}
@end
