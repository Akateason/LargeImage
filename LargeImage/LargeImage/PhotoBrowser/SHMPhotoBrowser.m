//
//  SHMPhotoBrowser.m
//  XTlib
//
//  Created by teason23 on 2020/2/20.
//  Copyright © 2020 teason23. All rights reserved.
//

#import "SHMPhotoBrowser.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "XTlib.h"
#import "SHMPhotoBrowserCell.h"


@interface SHMPhotoBrowser () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (copy, nonatomic) NSArray *datas;
@end

@implementation SHMPhotoBrowser

#pragma mark -

- (instancetype)initWithUrlStrs:(NSArray <NSString *> *)urlStrs {
    self = [super init];
    if (self) {
        self.datas = urlStrs;
        self.collectionView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.minimumLineSpacing = layout.minimumInteritemSpacing = 0;
            layout.itemSize = CGSizeMake(APP_WIDTH, APP_HEIGHT);
            
            UICollectionView *v = [[UICollectionView alloc] initWithFrame:APPFRAME collectionViewLayout:layout] ;
            [self addSubview:v];
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            v.collectionViewLayout = layout;
            v.dataSource = self;
            v.delegate = self;
            v.pagingEnabled = TRUE;
            v;
        });
        
        [self.collectionView registerClass:[SHMPhotoBrowserCell class] forCellWithReuseIdentifier:@"SHMPhotoBrowserCell"];
        
        
    }
    return self;
}




#pragma mark - UICollectionViewDataSource <NSObject>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHMPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHMPhotoBrowserCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    cell.urlStr = self.datas[indexPath.row];
    xt_LOG_DEBUG(@"加载第%@张",@(indexPath.row+1));
    
    
    return cell;
}


@end
