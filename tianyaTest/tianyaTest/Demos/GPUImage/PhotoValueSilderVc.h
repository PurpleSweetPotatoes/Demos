//
//  PhotoValueSilderVc.h
//  tianyaTest
//
//  Created by baiqiang on 2019/1/22.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "BQPopVc.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoValueSilderVc : BQPopVc
+ (void)showViewWithDictInfo:(NSDictionary *)dicInfo fromVc:(UIViewController *)fromVc proccessHandle:(void(^)(CGFloat brightness, CGFloat exposure, CGFloat contrast, CGFloat saturation))proccessHandle;
@end

NS_ASSUME_NONNULL_END
