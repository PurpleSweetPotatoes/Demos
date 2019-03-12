//
//  RequestUrl.h
//  tianyaTest
//
//  Created by baiqiang on 2019/2/15.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#ifndef RequestUrl_h
#define RequestUrl_h


static NSString * const kMvUrl = @"mv";                             ///< mv


static NSString * const kMetroInfoUrl = @"metro";                   ///< 地铁线路信息
static NSString * const kMetroPriceRuleUrl = @"metro/priceRule";    ///< 地铁票价规则
//参数 {from:站点id to:站点id}
static NSString * const kMetroPathSearchUrl = @"metro/search";      ///< 地铁线路查询


#endif /* RequestUrl_h */
