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



@interface ViewController ()
@property (nonatomic, strong) SHMLargeImgScroll *imgScroll;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    

//    UIImage *image = [UIImage imageNamed:@"bigbig.jpg"];
    UIImage *image = [UIImage imageNamed:@"1.png"];
    NSData *dataImage = UIImageJPEGRepresentation(image, .3);
    image = [UIImage imageWithData:dataImage];
    
    self.imgScroll = [[SHMLargeImgScroll alloc] initWithFrame:self.view.bounds];
    [self.imgScroll setupImage:image];
    [self.view addSubview:self.imgScroll];
    
    
    
    
}


@end
