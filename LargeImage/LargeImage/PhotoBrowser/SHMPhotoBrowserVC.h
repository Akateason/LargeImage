//
//  SHMPhotoBrowserVC.h
//  XTlib
//
//  Created by teason23 on 2020/2/20.
//  Copyright © 2020 teason23. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHMPhotoBrowser;

NS_ASSUME_NONNULL_BEGIN

@interface SHMPhotoBrowserVC : UIViewController
@property (copy, nonatomic) NSArray <NSString *> *urls ;
@property (strong, nonatomic) SHMPhotoBrowser *pb ;
+ (instancetype)setup:(NSArray <NSString *> *)urls ;
@end

NS_ASSUME_NONNULL_END
