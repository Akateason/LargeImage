//
//  SDWebImageManager+largeImage.m
//  LargeImageLoadTest
//
//  Created by ZYP on 2018/6/5.
//  Copyright © 2018年 ZYP. All rights reserved.
//

#import "SDWebImageManager+largeImage.h"

@implementation SDWebImageManager (largeImage)

+ (instancetype)sharedManagerForLargeImage {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] setup];
    });
    return instance;
}

- (nonnull instancetype)setup {
    SDImageCache *cache = [[SDImageCache alloc] initWithNamespace:@"largeImage"];
    cache.config.shouldDecompressImages = NO;
    cache.config.shouldCacheImagesInMemory = NO;
    SDWebImageDownloader *downloader = [[SDWebImageDownloader alloc] init];
    downloader.shouldDecompressImages = NO;
    downloader.maxConcurrentDownloads = 3;
    return [self initWithCache:cache downloader:downloader];
}

@end
