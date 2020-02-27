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
        [self setupGesture];
        [self largeImgView];
        [self imageView];
    }
    return self;
}

- (void)setupLargeImage:(UIImage *)img {
    [self clear];
    self.imageView.hidden = YES;
    self.largeImgView.hidden = NO;
    
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
    [self resetScrollToOrigin];
}

- (void)setupSDRender:(UIImage *)image {
    [self clear];
    self.imageView.hidden = NO;
    self.largeImgView.hidden = YES;
    self.maximumZoomScale = 3;
    self.minimumZoomScale = 1;
    
    self.imageView.image = image;
    [self resetScrollToOrigin];
}

- (void)setupGifData:(NSData *)data {
    [self clear];
    self.imageView.hidden = NO;
    self.largeImgView.hidden = YES;
    self.maximumZoomScale = 3;
    self.minimumZoomScale = 1;
    
    FLAnimatedImage *aImage = [FLAnimatedImage animatedImageWithGIFData:data];
    self.imageView.animatedImage = aImage;
    [self resetScrollToOrigin];
}



#pragma mark - gesture

- (void)setupGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];

    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    [tap requireGestureRecognizerToFail:doubleTap];
}

- (void)tap:(UITapGestureRecognizer *)tapGetrue {}

static const float kSIDE_ZOOMTORECT = 80.0f;
- (void)doubleTap:(UITapGestureRecognizer *)tapGesture {
    if (self.zoomScale == 1) {
        CGPoint point = [tapGesture locationInView:self];
        [self zoomToRect:CGRectMake(point.x - kSIDE_ZOOMTORECT / 2, point.y - kSIDE_ZOOMTORECT / 2, kSIDE_ZOOMTORECT, kSIDE_ZOOMTORECT) animated:YES];
    } else {
        [self setZoomScale:1 animated:YES];
        [self resetScrollToOrigin];
    }
}

#pragma mark - scrollview

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.largeImgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setuplargeImgViewFrame];
    self.imageView.frame = self.largeImgView.frame;
}


#pragma mark - p

- (SHMTiledLargeImageView *)largeImgView {
    if (!_largeImgView) {
        _largeImgView = [[SHMTiledLargeImageView alloc] initWithFrame:self.bounds];
        if (!_largeImgView.superview) [self addSubview:_largeImgView];
        _largeImgView.delegate = self;
    }
    return _largeImgView;
}

- (FLAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[FLAnimatedImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (!_imageView.superview) [self addSubview:_imageView];
    }
    return _imageView;
}

#pragma mark - util

- (void)setuplargeImgViewFrame {
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.largeImgView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else frameToCenter.origin.x = 0;
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else frameToCenter.origin.y = 0;
    
    self.largeImgView.frame = frameToCenter;
    // to handle the interaction between CATiledLayer and high resolution screens, we need to manually set the
    // tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens,
    // which would cause the CATiledLayer to ask us for tiles of the wrong scales.)
    self.largeImgView.contentScaleFactor = 1.0;
}

- (void)clear {
    self.imageView.animatedImage = nil;
    self.imageView.image = nil;
        
    self.largeImgView.image = nil;
}

- (void)resetScrollToOrigin {
    self.zoomScale = 1;
    [self setuplargeImgViewFrame];
    self.imageView.frame = self.bounds;
    [self scrollRectToVisible:self.bounds animated:NO];
}

- (void)compressBigPngIfNeeded:(UIImage *)image
                          data:(NSData *)data
                      complete:(void(^)(UIImage *image))completion {
    RACTuple *info = [self infoFromImage:image];
    CGFloat scale = [info.first floatValue];
    int lev = ceil(log2(1 / scale));
    if (lev >= 4) {
        //TODO: 分片压缩
        UIImage *imgCompressed = [SHMLargeImageCompressUtil scaledImageFromData:data width:APP_WIDTH * (lev+1)] ;
        if (completion) completion(imgCompressed);
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

- (void)setImgUrlString:(NSString *)urlString {
    [self clear];
    
    UIActivityIndicatorView *aiView   = [UIActivityIndicatorView new];
    aiView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    aiView.center                     = self.center;
    [self addSubview:aiView];
    [aiView startAnimating];
    
    @weakify(self)
    [[SDWebImageManager sharedManagerForLargeImage] loadImageWithURL:[NSURL URLWithString:urlString]
                                                             options:SDWebImageScaleDownLargeImages
                                                            progress:nil
                                                           completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {

        @strongify(self)
        SDImageFormat format = [NSData sd_imageFormatForImageData:data];
        [self imageDownloadFinished:image data:data sdFormat:format] ;
        
        [aiView stopAnimating];
        [aiView removeFromSuperview];
    }];
}

- (void)imageDownloadFinished:(UIImage *)image
                         data:(NSData *)data
                     sdFormat:(SDImageFormat)format {
    
    
    switch (format) {
        case SDImageFormatJPEG: {
            [self setupLargeImage:image];
        }
            break;
        case SDImageFormatPNG: {
            @weakify(self)
            [self compressBigPngIfNeeded:image data:data complete:^(UIImage *image) {
                @strongify(self)
                [self setupLargeImage:image];
            }];
        }
            break;
        case SDImageFormatGIF: {
            [self setupGifData:data];
        }
            break;
        case SDImageFormatTIFF:
        case SDImageFormatWebP:
        case SDImageFormatHEIC:
        case SDImageFormatUndefined: {
            [self setupSDRender:image] ;
        }
            break;
        default:
            break;
    }
}


@end
