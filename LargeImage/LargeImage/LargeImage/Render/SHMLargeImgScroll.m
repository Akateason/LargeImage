//
//  ImageScrollView.m
//  LoadLargeImage
//
//  Created by dcjt on 2018/12/18.
//  Copyright © 2018 dcjt. All rights reserved.
//

#import "SHMLargeImgScroll.h"
#import "SHMTiledLargeImageView.h"

@interface SHMLargeImgScroll ()<UIScrollViewDelegate>
@property (nonatomic, strong)    UIImage                *image;
@property (nonatomic, strong)    SHMTiledLargeImageView *tiledView;
@end

@implementation SHMLargeImgScroll

#pragma mark - life

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        self.backgroundColor = [UIColor blackColor];
        
        self.tiledView = [[SHMTiledLargeImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.tiledView];
    }
    return self;
}

- (void)setupImage:(UIImage *)img {
    // 根据图片实际尺寸 和 屏幕尺寸 计算图片视图尺寸
    self.image = img;
        
    CGRect imageRect = CGRectMake(0.0f,0.0f,CGImageGetWidth(self.image.CGImage),CGImageGetHeight(self.image.CGImage));
    CGFloat scaleW = self.frame.size.width / imageRect.size.width ;
    CGFloat scaleH = self.frame.size.height / imageRect.size.height ;
    CGFloat imageScale = MIN(scaleH, scaleW) ;
    imageRect.size = CGSizeMake(imageRect.size.width * imageScale,
                                imageRect.size.height * imageScale) ;
            
    // 根据图片的缩放计算scrollview的缩放级别
    // 图片相对于视图放大了1/imageScale倍，所以用log2(1/imageScale)得出缩放次数，
    int level = ceil(log2(1 / imageScale)) ;
    CGFloat zoomOutLevels = 1;
    CGFloat zoomInLevels = pow(2, level);
    
    self.maximumZoomScale = zoomInLevels;
    self.minimumZoomScale = zoomOutLevels;

    [self.tiledView setImage:img scale:imageScale] ;
    self.tiledView.frame = imageRect;
    [self setupTiledViewFrame];
}


#pragma mark - scrollview
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.tiledView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setupTiledViewFrame];
}



#pragma mark -

- (void)setupTiledViewFrame {
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.tiledView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    self.tiledView.frame = frameToCenter;
    // to handle the interaction between CATiledLayer and high resolution screens, we need to manually set the
    // tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens,
    // which would cause the CATiledLayer to ask us for tiles of the wrong scales.)
    self.tiledView.contentScaleFactor = 1.0;
}

@end
