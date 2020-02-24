//
//  ViewController.m
//  LargeImage
//
//  Created by dcjt on 2018/12/19.
//  Copyright © 2018 dcjt. All rights reserved.
//

#import "ViewController.h"
#import "ImageScrollView.h"
#import "TiledImageView.h"
//#import "YPLargeImageView.h"

@interface ViewController ()
@property (nonatomic, strong) ImageScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pic1.win4000.com/wallpaper/2018-12-17/5c1731baae242.jpg"]]];
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            if (image) {
    //                // do something with image
    //                self.scrollView = [[ImageScrollView alloc] initWithFrame:self.view.bounds image:image];
    //                [self.view addSubview:self.scrollView];
    //            }
    //        });
    //    });
    

//    UIImage *image = [UIImage imageNamed:@"bigbig.jpg"];
    UIImage *image = [UIImage imageNamed:@"1.png"];
    NSData *dataImage = UIImageJPEGRepresentation(image, .3);
    image = [UIImage imageWithData:dataImage];
    
    self.scrollView = [[ImageScrollView alloc] initWithFrame:self.view.bounds image:image];
    [self.view addSubview:self.scrollView];
    
    
//    TiledImageView *imgView = [[TiledImageView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:imgView];
//    [imgView xt_setImage:[UIImage imageNamed:@"1.png"] scale:0.029];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    YPLargeImageView *view = [[YPLargeImageView alloc] initWithFrame:self.view.bounds];
//    [view yp_setImageName:@"1.png"];
//    [self.view addSubview:view];
    
    
}


@end
