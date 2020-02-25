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

NS_ASSUME_NONNULL_BEGIN

@protocol SHMTiledLargeImageViewDelegate <NSObject>
- (void)imageDownloadFinished:(UIImage *)image sdFormat:(SDImageFormat)format;
@end

@interface SHMTiledLargeImageView : UIView
@property (weak, nonatomic)     id<SHMTiledLargeImageViewDelegate> delegate;
@property (strong, nonatomic)   UIImage   *image;
@property (nonatomic)           CGFloat   imageScale;



- (void)setImage:(UIImage *)image scale:(CGFloat)scale ;

- (void)setImgUrlString:(NSString *)urlString ;

@end

NS_ASSUME_NONNULL_END
