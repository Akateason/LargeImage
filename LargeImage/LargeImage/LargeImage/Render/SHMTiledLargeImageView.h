//
//  TiledImageView.h
//  LoadLargeImage
//
//  Created by dcjt on 2018/12/18.
//  Copyright © 2018 dcjt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHMTiledLargeImageView : UIView
@property (nonatomic, strong) UIImage   *image;
@property (nonatomic, assign) CGFloat   imageScale;


- (void)setImage:(UIImage *)image scale:(CGFloat)scale ;
@end

NS_ASSUME_NONNULL_END
