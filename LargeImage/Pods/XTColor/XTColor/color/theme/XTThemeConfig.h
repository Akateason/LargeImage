//
//  XTThemeConfig.h
//  XTColor
//
//  Created by teason23 on 2019/11/11.
//  Copyright © 2019 teason23. All rights reserved.
// 使用此类务必创建default.json文件作为默认主题, 参考sample中customTheme文件夹.

#import <Foundation/Foundation.h>
#import <XTBase/XTBase.h>
#import "NSObject+XTColorTheme.h"


@interface XTThemeConfig : NSObject
XT_SINGLETON_H(XTThemeConfig)
@property (copy, nonatomic, readonly) NSString *currentThemeKey ;

// 获取主题色
- (UIColor *)colorForkey:(NSString *)key ;

// 初始化主题色, 如果曾经改过主题色则会获取上一次最新的主题色.
- (void)setupDefaultTheme:(NSString *)defautTheme ;

// 切换主题
- (void)changeTheme:(NSString *)themeKey ;
@end


