//
//  WebImgModel.m
//  LargeImage
//
//  Created by teason23 on 2020/2/26.
//  Copyright © 2020 dcjt. All rights reserved.
//

#import "WebImgModel.h"

@implementation WebImgModel

- (BOOL)onlyTakeThumbnail {
    if ([self.image containsString:@".GIF"] || [self.image containsString:@"gif"]) {
        return YES;
    }
    return !self.origin;
}






+ (NSArray *)fakelist {
//        @[
//        @"https://images.smcdn.cn/femv2VR7Je0ZJciK/IMG_0719.GIF!original",
//        @"https://uploader.shimo.im/f/HFVhhHm0xqQHkbN4.jpg!original",
//        @"https://uploader.shimo.im/f/Sd3I7qTm200u3mvz.jpg!original",
//        @"https://images.smcdn.cn/qwBhOweddJkSN9o0/IMG_0015.JPG!thumbnail",
//        @"https://images.smcdn.cn/uIy0hOzBugkx18kH/IMG_0049.PNG!thumbnail",  //b
//    //    @"https://images.smcdn.cn/Ge2tGGPo4AYOEYt7/IMG_0051.PNG!original", //b
//        @"https://images.smcdn.cn/tWHH7Ncg6NEydnYL/IMG_0312.GIF!original",
//        @"https://img2018.cnblogs.com/blog/1449510/201905/1449510-20190520125900956-1796872904.png",
//        ];

    
    WebImgModel *m1 = [WebImgModel new];
    m1.image = @"https://images.smcdn.cn/femv2VR7Je0ZJciK/IMG_0719.GIF!thumbnail";
//    m1.origin = @"https://images.smcdn.cn/femv2VR7Je0ZJciK/IMG_0719.GIF!original",
        
    WebImgModel *m2 = [WebImgModel new];
    m2.image = @"https://uploader.shimo.im/f/HFVhhHm0xqQHkbN4.jpg!thumbnail";
    m2.origin = @"https://uploader.shimo.im/f/HFVhhHm0xqQHkbN4.jpg!original";
        
    WebImgModel *m3 = [WebImgModel new];
    m3.image = @"https://uploader.shimo.im/f/Sd3I7qTm200u3mvz.jpg!thumbnail";
    m3.origin = @"https://uploader.shimo.im/f/Sd3I7qTm200u3mvz.jpg!original";
    
    WebImgModel *m4 = [WebImgModel new];
    m4.image = @"https://images.smcdn.cn/qwBhOweddJkSN9o0/IMG_0015.JPG!thumbnail";
    m4.origin = @"https://images.smcdn.cn/qwBhOweddJkSN9o0/IMG_0015.JPG!original";
    
    WebImgModel *m5 = [WebImgModel new]; // big
    m5.image = @"https://images.smcdn.cn/uIy0hOzBugkx18kH/IMG_0049.PNG!thumbnail";
    m5.origin = @"https://images.smcdn.cn/uIy0hOzBugkx18kH/IMG_0049.PNG!original";
    
    WebImgModel *m6 = [WebImgModel new];
    m6.image = @"https://images.smcdn.cn/tWHH7Ncg6NEydnYL/IMG_0312.GIF!thumbnail";
    m6.origin = @"https://images.smcdn.cn/tWHH7Ncg6NEydnYL/IMG_0312.GIF!original";
    
    
    return @[m1,m2,m3,m4,m5,m6];
}

@end
