//
//  CollectionImgCell.h
//  tianyaTest
//
//  Created by baiqiang on 2019/1/4.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PhotoKitDemoVc.h"
NS_ASSUME_NONNULL_BEGIN

@interface CollectionImgCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *markBtn;

@property (nonatomic, weak) PHAsset * assetModel;

@end

NS_ASSUME_NONNULL_END
