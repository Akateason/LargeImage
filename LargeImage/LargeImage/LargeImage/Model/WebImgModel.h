//
//  WebImgModel.h
//  LargeImage
//
//  Created by teason23 on 2020/2/26.
//  Copyright © 2020 dcjt. All rights reserved.
//  { image: string; origin: string }


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebImgModel : NSObject
@property (nonatomic,copy) NSString *image;     //thumbnail
@property (nonatomic,copy) NSString *origin;

- (BOOL)onlyTakeThumbnail;

+ (NSArray *)fakelist;

@end

NS_ASSUME_NONNULL_END
