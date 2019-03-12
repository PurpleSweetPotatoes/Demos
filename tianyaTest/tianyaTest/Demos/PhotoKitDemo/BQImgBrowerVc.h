//
//  BQImgBrowerVc.h
//  tianyaTest
//
//  Created by baiqiang on 2019/1/8.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@class PHAsset;

@interface BQImgBrowerVc : UIViewController

- (instancetype)initWithAssets:(NSArray<PHAsset *> *)assetArr;

@end

NS_ASSUME_NONNULL_END
