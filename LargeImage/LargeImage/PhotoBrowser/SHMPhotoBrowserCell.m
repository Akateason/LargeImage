//
//  SHMPBItemCell.m
//  XTlib
//
//  Created by teason23 on 2020/2/20.
//  Copyright © 2020 teason23. All rights reserved.
//

#import "SHMPhotoBrowserCell.h"
#import <XTBase/XTBase.h>
#import <Masonry/Masonry.h>
#import "SHMLargeImgScroll.h"
#import "WebImgModel.h"


@interface SHMPhotoBrowserCell ()
@property (strong, nonatomic, readwrite)   SHMLargeImgScroll   *imgScroll;
@end

@implementation SHMPhotoBrowserCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
               
        self.imgScroll = ({
            SHMLargeImgScroll *v = [[SHMLargeImgScroll alloc] initWithFrame:self.bounds];
            [self addSubview:v];
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            v;
        });

    }
    return self;
}

- (void)setModel:(WebImgModel *)model {
    _model = model;
    
    [self.imgScroll goDownloadThumbnail:model];
        
}




@end
