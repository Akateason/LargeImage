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

#import <XTBase/XTBase.h>
#import <BlocksKit/UIView+BlocksKit.h>
#import <SDWebImage/SDWebImageManager.h>
#import "SDWebImageManager+largeImage.h"

#import "WebImgModel.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [XTlibConfig.sharedInstance defaultConfiguration];
    
    [super viewDidLoad];
    
    


    UIButton *bt = [UIButton new];
    [bt setTitle:@"clear" forState:0];
    bt.backgroundColor = [UIColor redColor];
    [self.view addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    [bt bk_whenTapped:^{
        
        [self cleanAll];

    }];


    
    
    
    
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
        NSArray *urls = [WebImgModel fakelist];
        SHMPhotoBrowserVC *vc = [SHMPhotoBrowserVC setup:urls];
        [self presentViewController:vc animated:YES completion:nil];

    }];

}


- (void)cleanAll {
//        clear sd default
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDiskOnCompletion:^{

    }];
    
//        clear large
    [SDWebImageManager.sharedManagerForLargeImage.imageCache clearMemory];
    [SDWebImageManager.sharedManagerForLargeImage.imageCache clearDiskOnCompletion:^{

    }];
    
//    drop WebImgModel
    [WebImgModel shmdb_dropTable];
        
}


@end
