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
#import "WebImgModel.h"

@interface SHMPhotoBrowserVC ()

@end

@implementation SHMPhotoBrowserVC

+ (instancetype)setup:(NSArray <WebImgModel *> *)webImages {
    SHMPhotoBrowserVC *vc = [[SHMPhotoBrowserVC alloc] initWithWebImgs:webImages];
    return vc;
}

- (instancetype)initWithWebImgs:(NSArray *)webImages {
    self = [super init];
    if (self) {
        self.webImages = webImages;
    }
    return self;
}

- (void)setWebImages:(NSArray<WebImgModel *> *)webImages {
    [webImages enumerateObjectsUsingBlock:^(WebImgModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WebImgModel *dbitem = [WebImgModel shmdb_findFirstWhere:[NSString stringWithFormat:@"image=='%@'",obj.image]];
        if (dbitem.image.length && dbitem) {
            obj.hasDownloadOrigin = dbitem.hasDownloadOrigin;
        }
    }];
    _webImages = webImages;
    
    [WebImgModel shmdb_insertOrIgnoreWithList:self.webImages];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pb = [[SHMPhotoBrowser alloc] initWithWebImgs:self.webImages];
    [self.view addSubview:self.pb];
    [self.pb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}




@end
