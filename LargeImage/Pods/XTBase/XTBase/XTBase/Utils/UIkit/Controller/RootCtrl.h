//
//  RootCtrl.h
//  Teason
//
//  Created by ; on 14-8-21.
//  Copyright (c) 2014年 TEASON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTBase.h"

@interface RootCtrl : UIViewController

@property (copy, nonatomic) NSString *customTitle; // a custom Title for VC if needed.

- (void)prepare;
- (void)prepareUI;

@end
