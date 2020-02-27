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

#import "WebImgModel.h"


@interface ViewController ()
@property (nonatomic, strong) SHMLargeImgScroll *imgScroll;
@end

@implementation ViewController

- (void)viewDidLoad {
    [XTlibConfig.sharedInstance defaultConfiguration];
    
    [super viewDidLoad];
    
    NSArray *urls = [WebImgModel fakelist];


    

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
        SHMPhotoBrowserVC *vc = [SHMPhotoBrowserVC setup:urls];
        [self presentViewController:vc animated:YES completion:nil];

    }];

}


@end
