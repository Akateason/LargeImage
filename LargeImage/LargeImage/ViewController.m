//
//  ViewController.m
//  LargeImage
//
//  Created by dcjt on 2018/12/19.
//  Copyright © 2018 dcjt. All rights reserved.
//

#import "ViewController.h"
#import "SHMLargeImgScroll.h"
#import "SHMTiledLargeImageView.h"

#import "SHMPhotoBrowserVC.h"

#import <XTlib/XTlib.h>
#import <BlocksKit/UIView+BlocksKit.h>
#import <SDWebImage/SDWebImageManager.h>


@interface ViewController ()
@property (nonatomic, strong) SHMLargeImgScroll *imgScroll;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *urls =
    @[
    @"https://images.smcdn.cn/uIy0hOzBugkx18kH/IMG_0049.PNG!original",
    @"https://images.smcdn.cn/Ge2tGGPo4AYOEYt7/IMG_0051.PNG!original"
    @"https://images.smcdn.cn/tWHH7Ncg6NEydnYL/IMG_0312.GIF!original",
    @"https://img2018.cnblogs.com/blog/1449510/201905/1449510-20190520125900956-1796872904.png",
    ];

    

//    clear sd
//    [SDWebImageManager.sharedManager.imageCache clearMemory];
//    [SDWebImageManager.sharedManager.imageCache clearDiskOnCompletion:^{
//
//    }];
    
    
    
    
//    UIImage *image = [UIImage imageNamed:@"bigbig.jpg"];
//    UIImage *image = [UIImage imageNamed:@"1.png"];
//    NSData *dataImage = UIImageJPEGRepresentation(image, .3);
//    image = [UIImage imageWithData:dataImage];
    
//    self.imgScroll = [[SHMLargeImgScroll alloc] initWithFrame:self.view.bounds];
//    [self.imgScroll setupImage:image];
//    [self.view addSubview:self.imgScroll];

    @weakify(self)
    [self.view bk_whenTapped:^{
        @strongify(self)
        SHMPhotoBrowserVC *vc = [SHMPhotoBrowserVC setup:@[
            @"https://images.smcdn.cn/tWHH7Ncg6NEydnYL/IMG_0312.GIF!original",
//            @"https://images.smcdn.cn/uIy0hOzBugkx18kH/IMG_0049.PNG!original"
        ]];
        [self presentViewController:vc animated:YES completion:nil];

    }];

}


@end
