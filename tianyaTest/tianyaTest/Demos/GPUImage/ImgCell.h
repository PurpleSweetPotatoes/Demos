//
//  ImgCell.h
//  tianyaTest
//
//  Created by baiqiang on 2019/1/21.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImgCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *filterName;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end

NS_ASSUME_NONNULL_END
