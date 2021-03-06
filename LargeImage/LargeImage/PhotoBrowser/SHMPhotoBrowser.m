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
#import "SHMPhotoBrowserCell.h"
#import "WebImgModel.h"
#import "SHMLargeImgScroll.h"
#import <XTBase/XTBase.h>

@interface SHMPhotoBrowser () <UICollectionViewDelegate,UICollectionViewDataSource,SHMLargeImgScrollCallback>
@property (copy, nonatomic)     NSArray             *datas;
@property (nonatomic)           NSInteger           currentIdx;

@property (strong, nonatomic)   UICollectionView    *collectionView;
@property (strong, nonatomic)   UILabel             *titleLabel;
@property (strong, nonatomic)   UIButton            *closeButton;
@property (strong, nonatomic)   UIButton            *saveImgButton;
@property (strong, nonatomic)   UIButton            *seeOriginButton;
@end

@implementation SHMPhotoBrowser

#pragma mark - life

- (instancetype)initWithWebImgs:(NSArray <WebImgModel *> *)models {
    self = [super init];
    if (self) {
        self.datas = models;
        [self setupUI];
        [self setup];
        self.currentIdx = 0;
    }
    return self;
}


- (void)setup {
    @weakify(self)
    [[self.closeButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.xt_viewController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [[self.saveImgButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"TODO 保存到本地");
        
    }];
    
    [[self.seeOriginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        NSLog(@"点击 下载 大图");
        @strongify(self)
        [self downloadCurrentOriginImage];
    }];
    
    
    
    // 滑动之后. 过一秒. 去切换大图
    [[[RACObserve(self, currentIdx) throttle:1]
      deliverOnMainThread]
     subscribeNext:^(NSNumber *x) {
        @strongify(self)
        if (!self.window) return ;
        
        //确认加载Mode 1.是否存在原图 2.是否已下载原图.
        //1.是否存在原图
        WebImgModel *aModel = self.datas[x.integerValue];
        if ([aModel onlyTakeThumbnail] ) return;  //不存在原图
        
        //存在原图 2.是否已下载原图.
        if (aModel.hasDownloadOrigin) { //已下载. 通知切换
            NSLog(@"已下载. 通知切换");
            [self downloadCurrentOriginImage];
        } else {
            //未下载. 保持
        }
    }];
    
    
    
    
}

- (void)downloadCurrentOriginImage {
    SHMPhotoBrowserCell *cell = (SHMPhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIdx inSection:0]];
    [cell.imgScroll goDownloadLarge:self.datas[self.currentIdx]];
}


#pragma mark - setter

- (void)setCurrentIdx:(NSInteger)currentIdx {
    _currentIdx = currentIdx;
    
    WebImgModel *aModel = self.datas[currentIdx];
    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%lu",currentIdx+1,(unsigned long)self.datas.count];
    if ([aModel onlyTakeThumbnail]) {
        self.seeOriginButton.hidden = YES;
    } else {
        self.seeOriginButton.hidden = aModel.hasDownloadOrigin;
        
        if ( !aModel.hasDownloadOrigin ) {
            [self.seeOriginButton setTitle:@"查看原图" forState:0];
        }
    }
    
        
}


#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHMPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHMPhotoBrowserCell" forIndexPath:indexPath];
    cell.model = self.datas[indexPath.row];
    cell.imgScroll.callback = self;
//    xt_LOG_DEBUG(@"加载第%@张",@(indexPath.row+1));
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.currentIdx = 0 + scrollView.contentOffset.x / APP_WIDTH;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 触发滑动的时候. 全部切换缩略图
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoti_ResetToThumbNail object:nil];
}

#pragma mark - SHMLargeImgScrollCallback <NSObject>
static NSString *const kStrLoadingStart = @"加载中...";
static NSString *const kStrLoaded       = @"已完成";

- (void)downloadLargeImageProgressVal:(float)val {
//    NSLog(@"val : %@", @(val));
    val *= 100.0f;
    val = val?:0;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *str = val >= 100 ? kStrLoadingStart : [NSString stringWithFormat:@"%.1f%%",val] ;
        [self.seeOriginButton setTitle:str forState:0];
    });
}

- (void)largeImgStartLoading:(WebImgModel *)model {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.seeOriginButton setTitle:kStrLoadingStart forState:0];
    });
}

- (void)largeImgloadingFinished:(WebImgModel *)model {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.seeOriginButton setTitle:kStrLoaded forState:0];
                
        [UIView animateWithDuration:.2 delay:.4 options:0 animations:^{
            self.seeOriginButton.alpha = .2;
        } completion:^(BOOL finished) {
            self.seeOriginButton.hidden = YES;
            self.seeOriginButton.alpha = 1;
        }];
    });
}
















#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        if (!_titleLabel.superview) {
            [self addSubview:_titleLabel];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                if (@available(iOS 11.0, *)) {
                    make.centerY.equalTo(self.mas_safeAreaLayoutGuideTop).offset(32);
                } else {
                    make.centerY.equalTo(self.mas_top).offset(32+APP_STATUSBAR_HEIGHT);
                }
            }];
        }
    }
    return _titleLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton new];
        [_closeButton setTitle:@"关" forState:0];
        _closeButton.backgroundColor = [UIColor blueColor];
        if (!_closeButton.superview) {
            [self addSubview:_closeButton];
            [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(10);
                if (@available(iOS 11.0, *)) {
                    make.centerY.equalTo(self.mas_safeAreaLayoutGuideTop).offset(32);
                } else {
                    make.centerY.equalTo(self.mas_top).offset(32+APP_STATUSBAR_HEIGHT);
                }
                make.size.mas_equalTo(CGSizeMake(44, 44));
            }];
        }
    }
    return _closeButton;
}

- (UIButton *)saveImgButton {
    if (!_saveImgButton) {
        _saveImgButton = [UIButton new];
        [_saveImgButton setTitle:@"↓" forState:0];
        _saveImgButton.backgroundColor = [UIColor brownColor];
        if (!_saveImgButton.superview) {
            [self addSubview:_saveImgButton];
            [_saveImgButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(30, 30));
                make.right.equalTo(self).offset(-17);
                make.bottom.equalTo(self.mas_bottom).offset(-18);
            }];
        }
    }
    return _saveImgButton;
}

- (UIButton *)seeOriginButton {
    if (!_seeOriginButton) {
        _seeOriginButton = [UIButton new];
        [_seeOriginButton setTitle:@"查看原图" forState:0];
        [_seeOriginButton setTitleColor:[UIColor whiteColor] forState:0];
        _seeOriginButton.xt_borderColor = [UIColor whiteColor];
        _seeOriginButton.xt_borderWidth = .5;
        _seeOriginButton.xt_cornerRadius = 3;
        
        if (!_seeOriginButton.superview) {
            [self addSubview:_seeOriginButton];
            [_seeOriginButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(112, 26));
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.saveImgButton.mas_bottom);
            }];
        }
    }
    return _seeOriginButton;
}


- (void)setupUI {
    self.collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
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
    [self closeButton];
    [self saveImgButton];
    [self seeOriginButton];
}

@end
