//
//  SHMDBConst.h
//  SHMDatabase
//
//  Created by teason23 on 2018/10/25.
//  Copyright © 2018年 teason23. All rights reserved.
//
#import "SHMDatabaseSDK.h"

#ifndef SHMDBConst_h
#define SHMDBConst_h

#define SHMDBLog1(format, ...)              \
do {                                     \
fprintf(stderr, "🌙🌙🌙shmdb🌙🌙🌙\n");   \
(NSLog)((format), ##__VA_ARGS__);    \
fprintf(stderr, "🌙🌙🌙shmdb🌙🌙🌙\n\n"); \
} while (0)

#define SHMDBLog(format, ...)               \
if (SHMDB_isDebug) {                    \
SHMDBLog1((format), ##__VA_ARGS__); \
};

#endif /* SHMDBConst_h */
