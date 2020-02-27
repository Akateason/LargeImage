//
//  TiledImageView.h
//  LoadLargeImage
//
//  Created by dcjt on 2018/12/18.
//  Copyright © 2018 dcjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager+largeImage.h"
#import <UIImageView+WebCache.h>
#import <NSData+ImageContentType.h>

@interface SHMTiledLargeImageView : UIView
@property (strong, nonatomic)   UIImage   *image;
@property (nonatomic)           CGFloat   imageScale;



- (void)setImage:(UIImage *)image scale:(CGFloat)scale ;



@end


