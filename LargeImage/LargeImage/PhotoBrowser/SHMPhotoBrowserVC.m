//
//  SHMPhotoBrowserVC.m
//  XTlib
//
//  Created by teason23 on 2020/2/20.
//  Copyright © 2020 teason23. All rights reserved.
//

#import "SHMPhotoBrowserVC.h"
#import "SHMPhotoBrowser.h"
#import <Masonry/Masonry.h>

@interface SHMPhotoBrowserVC ()

@end

@implementation SHMPhotoBrowserVC

+ (instancetype)setup:(NSArray <NSString *> *)urls {
    SHMPhotoBrowserVC *vc = [[SHMPhotoBrowserVC alloc] initWithUrls:urls];
    return vc;
}

- (instancetype)initWithUrls:(NSArray *)urls {
    self = [super init];
    if (self) {
        self.urls = urls;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pb = [[SHMPhotoBrowser alloc] initWithUrlStrs:self.urls];
    [self.view addSubview:self.pb];
    [self.pb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    

    
    
}


@end
