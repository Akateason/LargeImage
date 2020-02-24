//
//  XTThemeConfig.m
//  XTColor
//
//  Created by teason23 on 2019/11/11.
//  Copyright © 2019 teason23. All rights reserved.
//

#import "XTThemeConfig.h"
#import "XTColor.h"


static NSString *const klastThemeNameKey = @"klastThemeNameKey" ;

@interface XTThemeConfig ()
@property (copy, nonatomic, readwrite)NSString *currentThemeKey ;
@property (copy, nonatomic) NSDictionary *dictionColors ;

@end

@implementation XTThemeConfig
XT_SINGLETON_M(XTThemeConfig)

- (UIColor *)colorForkey:(NSString *)key {
    NSString *colorCode = self.dictionColors[key] ;
    return UIColorHex(colorCode) ;
}

- (void)setupDefaultTheme:(NSString *)defautTheme {
    NSString *lastKey = XT_USERDEFAULT_GET_VAL(klastThemeNameKey) ;
    if (!lastKey || !lastKey.length) {
        lastKey = defautTheme ;
    }
    
    [self changeTheme:lastKey] ;
}

- (void)changeTheme:(NSString *)themeKey {
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:themeKey ofType:@"json"] ;
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    if (!data) return ;
    
    self.dictionColors = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    XT_USERDEFAULT_SET_VAL(themeKey, klastThemeNameKey) ;
    self.currentThemeKey = themeKey ;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForThemeColorDidChanged object:nil] ;
}

@end
