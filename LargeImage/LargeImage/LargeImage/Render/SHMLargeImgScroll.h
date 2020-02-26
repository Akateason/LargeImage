//
//  ImageScrollView.h
//  LoadLargeImage
//
//  Created by dcjt on 2018/12/18.
//  Copyright © 2018 dcjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHMTiledLargeImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHMLargeImgScroll : UIScrollView
@property (nonatomic, strong)    SHMTiledLargeImageView *largeImgView;

- (void)setupImage:(UIImage *)img ;
@end

NS_ASSUME_NONNULL_END
