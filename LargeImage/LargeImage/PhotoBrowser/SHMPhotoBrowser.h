//
//  SHMPhotoBrowser.h
//  XTlib
//
//  Created by teason23 on 2020/2/20.
//  Copyright © 2020 teason23. All rights reserved.
//
//  photo browser View - 大图详情 -

#import <UIKit/UIKit.h>

@class WebImgModel;

NS_ASSUME_NONNULL_BEGIN



@interface SHMPhotoBrowser : UIView
- (instancetype)initWithWebImgs:(NSArray <WebImgModel *> *)models;
@end

NS_ASSUME_NONNULL_END
