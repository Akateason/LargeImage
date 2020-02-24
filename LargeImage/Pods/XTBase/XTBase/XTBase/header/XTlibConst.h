//
//  XTlibConst.h
//  XTlib
//
//  Created by teason23 on 2018/10/18.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "XTlibConfig.h"

#ifndef XTlibConst_h
#define XTlibConst_h


#define LOG_LEVEL_DEF ddLogLevel
#import <CocoaLumberjack/CocoaLumberjack.h>
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif
#define __FILENAME__                    (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)
#define xt_LOG_INFO(format, ...)       DDLogInfo((@"[INFO🍎]\t[%s]\t""[%s]\t""[%d]\n" format @"\n============================================================================================================================"), __FILENAME__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define xt_LOG_DEBUG(format, ...)      DDLogError((@"[DEBUG🐛]\t[%s]\t""[%s]\t""[%d]\n" format @"\n============================================================================================================================"), __FILENAME__, __FUNCTION__, __LINE__, ##__VA_ARGS__);













#endif /* XTlibConst_h */
