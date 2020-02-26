//
//  ImageScrollView.m
//  LoadLargeImage
//
//  Created by dcjt on 2018/12/18.
//  Copyright © 2018 dcjt. All rights reserved.
//

#import "SHMLargeImgScroll.h"
#import <ReactiveObjC.h>
#import "SHMLargeImageCompressUtil.h"
#import <XTlib/XTlib.h>

@interface SHMLargeImgScroll ()<UIScrollViewDelegate, SHMTiledLargeImageViewDelegate>
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
        
        self.largeImgView = [[SHMTiledLargeImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.largeImgView];
        self.largeImgView.delegate = self ;
    }
    return self;
}



- (void)setupLargeImage:(UIImage *)img {
    RACTuple *info = [self infoFromImage:img];
    RACTupleUnpack(NSNumber *scaleNum, NSValue *rectVal) = info ;
    CGFloat imageScale = scaleNum.floatValue;
    CGRect imageRect = rectVal.CGRectValue;
                        
    // 根据图片的缩放计算Scrollview的缩放级别
    // 图片相对于视图放大了 1 / imageScale 倍，所以用log2(1/imageScale)得出缩放次数，
    int level = ceil(log2(1 / imageScale)) ;
    CGFloat zoomOutLevels = 1;
    CGFloat zoomInLevels = pow(2, level);
    
    self.maximumZoomScale = zoomInLevels;
    self.minimumZoomScale = zoomOutLevels;

    [self.largeImgView setImage:img scale:imageScale] ;
    self.largeImgView.frame = imageRect;
    [self setuplargeImgViewFrame];
}

// TODO . sd 方法 . gif 加载等
- (void)setupSDRender:(UIImage *)image {
//    self.
}

#pragma mark - scrollview

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.largeImgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setuplargeImgViewFrame];
}

#pragma mark - SHMTiledLargeImageViewDelegate <NSObject>

- (void)imageDownloadFinished:(UIImage *)image data:(NSData *)data sdFormat:(SDImageFormat)format {
    switch (format) {
        case SDImageFormatJPEG: {
            [self setupLargeImage:image];
        }
            break;
        case SDImageFormatPNG: {
            //TODO: 判断是否需要 压缩
            @weakify(self)
            [self compressBigPngIfNeeded:image data:data complete:^(UIImage *image) {
                @strongify(self)
                [self setupLargeImage:image];
            }];
        }
            break;
            
        case SDImageFormatGIF:
        case SDImageFormatTIFF:
        case SDImageFormatWebP:
        case SDImageFormatHEIC:
        case SDImageFormatUndefined: {
            //TODO: render other
            [self setupSDRender:image] ;
        }
            break;
        default:
            break;
    }
    
    
}


#pragma mark -

- (void)setuplargeImgViewFrame {
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.largeImgView.frame;
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
    self.largeImgView.frame = frameToCenter;
    // to handle the interaction between CATiledLayer and high resolution screens, we need to manually set the
    // tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens,
    // which would cause the CATiledLayer to ask us for tiles of the wrong scales.)
    self.largeImgView.contentScaleFactor = 1.0;
}

- (void)compressBigPngIfNeeded:(UIImage *)image
                          data:(NSData *)data
                      complete:(void(^)(UIImage *image))completion {
    RACTuple *info = [self infoFromImage:image];
    CGFloat scale = [info.first floatValue];
    int lev = ceil(log2(1 / scale)); //缩放次数
    if (lev >= 4) {
        
        if (completion) completion(image);
        
//        [SHMLargeImageCompressUtil downsize:image complete:^(UIImage * _Nonnull image1) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (completion) completion(image1);
//            });
//        }] ;
//        UIImage *imgCompressed = [SHMLargeImageCompressUtil thumbnailForAsset:data maxPixelSize:4];
        
//        UIImage *imgCompressed = [SHMLargeImageCompressUtil scaledImageFromData:data width:APP_WIDTH * 6] ;
//        if (completion) completion(imgCompressed);
        
        
    } else {
        if (completion) completion(image);
    }
}

/// infoFromImage
/// @return tuple @[@(imageScale), @(imageRect)]
/// 根据图片实际尺寸 和 屏幕尺寸 计算图片视图尺寸
- (RACTuple *)infoFromImage:(UIImage *)img {
    CGRect imageRect = CGRectMake(0.0f,0.0f,CGImageGetWidth(img.CGImage),CGImageGetHeight(img.CGImage));
    CGFloat scaleW = self.frame.size.width / imageRect.size.width ;
    CGFloat scaleH = self.frame.size.height / imageRect.size.height ;
    CGFloat imageScale = MIN(scaleH, scaleW) ;
    imageRect.size = CGSizeMake(imageRect.size.width * imageScale, imageRect.size.height * imageScale) ;
    return RACTuplePack(@(imageScale),@(imageRect));
}

@end
