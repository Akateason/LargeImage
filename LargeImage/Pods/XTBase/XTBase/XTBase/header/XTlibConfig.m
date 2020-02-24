//
//  XTlibConfig.m
//  XTlib
//
//  Created by teason23 on 2018/10/18.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "XTlibConfig.h"
#import <CocoaLumberjack/CocoaLumberjack.h>


@implementation XTlibConfig
XT_SINGLETON_M(XTlibConfig);

- (void)defaultConfiguration {
    self.isShowControllerLifeCycle = YES ;
    
    
    // CocoaLumberjack
    [self configCocoaLumberjack] ;
}

- (void)configCocoaLumberjack {
    [DDLog addLogger:[DDOSLogger sharedInstance]]; // Uses os_log

    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}



@end
