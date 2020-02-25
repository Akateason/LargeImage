//
//  TiledImageView.m
//  LoadLargeImage
//
//  Created by dcjt on 2018/12/18.
//  Copyright © 2018 dcjt. All rights reserved.
//

#import "SHMTiledLargeImageView.h"
#import "SHMTiledLayer.h"
#import <XTlib/XTlib.h>

@interface SHMTiledLargeImageView ()
@property (nonatomic, assign) CGRect    imageRect;
@end

@implementation SHMTiledLargeImageView



- (void)setImgUrlString:(NSString *)urlString {
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
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageDownloadFinished:sdFormat:)]) [self.delegate imageDownloadFinished:image sdFormat:format] ;
        
        [aiView stopAnimating];
        [aiView removeFromSuperview];
    }];

    
    
    
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlString]
//                      placeholderImage:nil
//                               options:SDWebImageAvoidDecodeImage
//                              progress:nil
//                             completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        @strongify(self)
//        [self setupWhenImageFetched:image];
//        [aiView stopAnimating];
//        [aiView removeFromSuperview];
//        self.blkLoadComplete();
//    }];

}


- (void)setImage:(UIImage *)image scale:(CGFloat)scale {
    self.image = image;
    _imageRect = CGRectMake(0.0f, 0.0f,
                            CGImageGetWidth(self.image.CGImage),
                            CGImageGetHeight(self.image.CGImage));
    _imageScale = scale;
    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
    //根据图片的缩放计算scrollview的缩放次数
    // 图片相对于视图放大了1/imageScale倍，所以用log2(1/imageScale)得出缩放次数，
    // 然后通过pow得出缩放倍数，至于为什么要加1，
    // 是希望图片在放大到原图比例时，还可以继续放大一次（即2倍），可以看的更清晰
    int lev = ceil(log2(1 / scale));
    tiledLayer.levelsOfDetail = 1;
    tiledLayer.levelsOfDetailBias = lev;
//    tiledLayer.tileSize  此处tilesize使用默认的256x256即可
//    tiledLayer.tileSize = CGSizeMake(100, 100);
}

- (void)drawRect:(CGRect)rect {
    @autoreleasepool{
        CGRect imageCutRect = CGRectMake(rect.origin.x / _imageScale,
                                         rect.origin.y / _imageScale,
                                         rect.size.width / _imageScale,
                                         rect.size.height / _imageScale);
        CGImageRef imageRef = CGImageCreateWithImageInRect(self.image.CGImage, imageCutRect);
        UIImage *tileImage = [UIImage imageWithCGImage:imageRef];
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(context);
        [tileImage drawInRect:rect];
        CGImageRelease(imageRef);
        UIGraphicsPopContext();
    }
}

+ (Class)layerClass {
    return [SHMTiledLayer class];
}

@end
