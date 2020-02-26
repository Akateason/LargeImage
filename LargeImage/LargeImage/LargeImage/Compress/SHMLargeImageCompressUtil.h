//
//  SHMLargeImageCompressUtil.h
//  LargeImage
//
//  Created by teason23 on 2020/2/25.
//  Copyright © 2020 dcjt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHMLargeImageCompressUtil : NSObject

+ (void)downsize:(nullable UIImage *)sourceImage complete:(void(^)(UIImage *image))completion ;


+ (UIImage *)thumbnailForAsset:(NSData *)assetData maxPixelSize:(NSUInteger)size ;
    


+ (UIImage *)scaledImageFrom:(NSURL *)imageUrl width:(CGFloat)width ;
+ (UIImage *)scaledImageFromData:(NSData *)data width:(CGFloat)width ;

@end

NS_ASSUME_NONNULL_END
