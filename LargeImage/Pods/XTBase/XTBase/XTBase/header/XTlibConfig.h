//
//  XTlibConfig.h
//  XTlib
//
//  Created by teason23 on 2018/10/18.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FastCodeHeader.h"

NS_ASSUME_NONNULL_BEGIN


@interface XTlibConfig : NSObject
XT_SINGLETON_H(XTlibConfig);

// 控制Ctrl生命周期是否打印. default NO
@property (nonatomic) BOOL isShowControllerLifeCycle;


// 在AppDelegate. didFinishLaunchingWithOptions 加入默认配置.
- (void)defaultConfiguration;
@end

NS_ASSUME_NONNULL_END
