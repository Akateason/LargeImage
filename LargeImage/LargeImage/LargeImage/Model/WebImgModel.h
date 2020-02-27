//
//  WebImgModel.h
//  LargeImage
//
//  Created by teason23 on 2020/2/26.
//  Copyright © 2020 dcjt. All rights reserved.
//  { image: string; origin: string }


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WebImgModelisplayMode) {
    WebImgModelisplayMode_thumbnail = 0 ,
    WebImgModelisplayMode_origin,
};


@interface WebImgModel : NSObject
@property (nonatomic,copy) NSString *image;     //thumbnail
@property (nonatomic,copy) NSString *origin;

@property (nonatomic) WebImgModelisplayMode currentDisplayMode ;

- (BOOL)onlyTakeThumbnail;

+ (NSArray *)fakelist;

@end

NS_ASSUME_NONNULL_END
