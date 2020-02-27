//
//  SHMPBItemCell.h
//  XTlib
//
//  Created by teason23 on 2020/2/20.
//  Copyright © 2020 teason23. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHMLargeImgScroll,WebImgModel;


NS_ASSUME_NONNULL_BEGIN

@interface SHMPhotoBrowserCell : UICollectionViewCell
@property (strong, nonatomic)             WebImgModel         *model;
@property (strong, nonatomic, readonly)   SHMLargeImgScroll   *imgScroll;
@end

NS_ASSUME_NONNULL_END
