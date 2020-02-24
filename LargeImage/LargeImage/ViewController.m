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



@interface ViewController ()
@property (nonatomic, strong) ImageScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    

//    UIImage *image = [UIImage imageNamed:@"bigbig.jpg"];
    UIImage *image = [UIImage imageNamed:@"1.png"];
    NSData *dataImage = UIImageJPEGRepresentation(image, .3);
    image = [UIImage imageWithData:dataImage];
    
    self.scrollView = [[ImageScrollView alloc] initWithFrame:self.view.bounds image:image];
    [self.view addSubview:self.scrollView];
    
    
    
    
}


@end
