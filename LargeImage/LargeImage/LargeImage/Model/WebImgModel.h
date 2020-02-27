//
//  WebImgModel.h
//  LargeImage
//
//  Created by teason23 on 2020/2/26.
//  Copyright © 2020 dcjt. All rights reserved.
//  save in database.
//  { image: string; origin: string }


#import <Foundation/Foundation.h>
#import <SHMDatabase.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kNoti_ResetToThumbNail   = @"kNoti_ResetToThumbNail";
//static NSString *const kNoti_DownloadLargeImage = @"kNoti_DownloadLargeImage";

typedef NS_ENUM(NSUInteger, WebImgModelisplayMode) {
    WebImgModelisplayMode_thumbnail = 0 ,
    WebImgModelisplayMode_origin,
};


@interface WebImgModel : NSObject

@property (nonatomic,copy) NSString *image;     //thumbnail
@property (nonatomic,copy) NSString *origin;
@property (nonatomic)      int      hasDownloadOrigin;



- (BOOL)onlyTakeThumbnail;

+ (NSArray *)fakelist;

@end

NS_ASSUME_NONNULL_END
