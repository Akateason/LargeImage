//
//  ImageScrollView.h
//  LoadLargeImage
//
//  Created by dcjt on 2018/12/18.
//  Copyright © 2018 dcjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHMTiledLargeImageView.h"
#import "WebImgModel.h"
#import <SDWebImage.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SHMLargeImgScrollCallback <NSObject>
@required
- (void)downloadLargeImageProgressVal:(float)val;
- (void)largeImgStartLoading:(WebImgModel *)model;
- (void)largeImgloadingFinished:(WebImgModel *)model;
@end


@interface SHMLargeImgScroll : UIScrollView
@property (weak, nonatomic)      id<SHMLargeImgScrollCallback>  callback;
@property (strong, nonatomic)    SHMTiledLargeImageView         *largeImgView;
@property (strong, nonatomic)    SDAnimatedImageView            *imageView;


- (void)goDownloadThumbnail:(WebImgModel *)model ;

- (void)goDownloadLarge:(WebImgModel *)model ;

@end

NS_ASSUME_NONNULL_END
