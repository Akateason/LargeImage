//
//  NSObject+XTColorTheme.h
//  XTColor
//
//  Created by teason23 on 2019/11/11.
//  Copyright © 2019 teason23. All rights reserved.
//




#import <Foundation/Foundation.h>

static NSString *const kNotificationForThemeColorDidChanged = @"kNotificationForXTThemeColorDidChanged" ;



@interface NSObject (XTColorTheme)
/// UIView , UIBarButtonItem
@property (copy, nonatomic) NSString *xt_theme_backgroundColor ;
/// UILabel , UIButton , UITextField, UITextView
@property (copy, nonatomic) NSString *xt_theme_textColor ;
/// UIImage , UIButton
@property (copy, nonatomic) NSString *xt_theme_imageColor ;

@end


