//
//  PhotoKitDemoVc.h
//  tianyaTest
//
//  Created by baiqiang on 2019/1/4.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoKitDemoVc : UIViewController

@end

@interface PHAsset(Selected)
@property (nonatomic, assign) BOOL selected;         ///<  是否选中
@end

NS_ASSUME_NONNULL_END
