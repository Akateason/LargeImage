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
#import <XTBase/XTBase.h>

@interface SHMLargeImgScroll ()<UIScrollViewDelegate>
@property (strong, nonatomic)    WebImgModel                    *myModel ;

@property (nonatomic) WebImgModelisplayMode currentDisplayMode ;
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
        [self setupNotifications];
    }
    return self;
}

- (void)setupNotifications {
    @weakify(self)
    [[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kNoti_ResetToThumbNail object:nil]
      deliverOnMainThread]
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        self.currentDisplayMode = WebImgModelisplayMode_thumbnail;
        
        self.largeImgView.image = nil; // 删除大图
        self.largeImgView.hidden = YES;
    }] ;
    

}

- (void)setupLargeImage:(UIImage *)img {
    [self clear];
        
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
    
    self.largeImgView.hidden = NO;
    NSLog(@"正在加载大图");
    if (self.currentDisplayMode == WebImgModelisplayMode_origin) [self.callback largeImgloadingFinished:self.myModel] ;
}

- (void)setupSDRender:(UIImage *)image {
    [self clear];
    self.largeImgView.hidden = YES;
    self.maximumZoomScale = 3;
    self.minimumZoomScale = 1;
    
    self.imageView.image = image;
    [self resetScrollToOrigin];
    
    if (self.currentDisplayMode == WebImgModelisplayMode_origin) [self.callback largeImgloadingFinished:self.myModel] ;
}

- (void)setupGifData:(NSData *)data {
    [self clear];
    self.largeImgView.hidden = YES;
    self.maximumZoomScale = 3;
    self.minimumZoomScale = 1;
    
    SDAnimatedImage *aImage = [SDAnimatedImage imageWithData:data];
    self.imageView.image = aImage;
//    self.imageView.animatedImage = aImage;
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
    }
    return _largeImgView;
}

- (SDAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[SDAnimatedImageView alloc] initWithFrame:self.bounds];
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
//    self.imageView.image = nil;
//    self.imageView.animatedImage = nil;
//    self.imageView.alpha = 1;
    
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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *imgCompressed = [SHMLargeImageCompressUtil scaledImageFromData:data width:APP_WIDTH * (lev+1)] ;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(imgCompressed);
            });
        });
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


- (void)goDownload:(WebImgModel *)model {
    self.myModel = model;
    
    NSString *urlString;
    switch (self.currentDisplayMode) {
        case WebImgModelisplayMode_thumbnail: urlString = model.image; break;
        case WebImgModelisplayMode_origin: urlString = model.origin; break;
        default: break;
    }
                
    UIActivityIndicatorView *aiView;
    if (self.currentDisplayMode == WebImgModelisplayMode_thumbnail) {
        aiView = [UIActivityIndicatorView new];
        aiView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        aiView.center                     = self.center;
        [self addSubview:aiView];
        [aiView startAnimating];
    }
    
    @weakify(self)
    [[SDWebImageManager sharedManagerForLargeImage] loadImageWithURL:[NSURL URLWithString:urlString]
                                                             options:SDWebImageAvoidDecodeImage | SDWebImageScaleDownLargeImages
                                                            progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
        @strongify(self)
        if (self.currentDisplayMode == WebImgModelisplayMode_origin && self.callback) {
            [self.callback downloadLargeImageProgressVal:(float)receivedSize / (float)expectedSize];
        }
    }
                                                           completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {

        @strongify(self)
        if (self.currentDisplayMode == WebImgModelisplayMode_thumbnail) {
            [aiView stopAnimating];
            [aiView removeFromSuperview];
        } else {
            [self.callback largeImgStartLoading:self.myModel] ;
        }
        
        SDImageFormat format = [NSData sd_imageFormatForImageData:data];
        [self imageDownloadFinished:image data:data sdFormat:format] ;
        if (self.currentDisplayMode == WebImgModelisplayMode_origin && !model.hasDownloadOrigin) {
            model.hasDownloadOrigin = 1;
            [model shmdb_upsertWhereByProp:@"image"];
        }
        
    }];
}

- (void)imageDownloadFinished:(UIImage *)image
                         data:(NSData *)data
                     sdFormat:(SDImageFormat)format {
    
    if (self.currentDisplayMode == WebImgModelisplayMode_thumbnail) {
        if (format == SDImageFormatGIF) [self setupGifData:data];
        else [self setupSDRender:image] ;
    } else {
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
}


- (void)goDownloadLarge:(WebImgModel *)model {
    if (![self.myModel.image isEqualToString:model.image]) return;
    if (self.currentDisplayMode == WebImgModelisplayMode_origin) return;
            
    self.currentDisplayMode = WebImgModelisplayMode_origin;
    self.largeImgView.hidden = NO;
    [self goDownload:model];
}

- (void)goDownloadThumbnail:(WebImgModel *)model {
    self.currentDisplayMode = WebImgModelisplayMode_thumbnail;
    [self clear];
    self.imageView.image = nil;
    [self goDownload:model];
}


@end
