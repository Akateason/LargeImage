//
//  ImageScrollView.h
//  LoadLargeImage
//
//  Created by dcjt on 2018/12/18.
//  Copyright © 2018 dcjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHMTiledLargeImageView.h"
#import <FLAnimatedImageView+WebCache.h>

NS_ASSUME_NONNULL_BEGIN



@interface SHMLargeImgScroll : UIScrollView
@property (nonatomic, strong)    SHMTiledLargeImageView         *largeImgView;
@property (nonatomic, strong)    FLAnimatedImageView            *imageView;


//TODO: param model
- (void)setImgUrlString:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
