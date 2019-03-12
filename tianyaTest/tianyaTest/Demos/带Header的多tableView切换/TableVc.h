//
//  TableVc.h
//  tianyaTest
//
//  Created by baiqiang on 2019/3/12.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableVc : UIViewController <BQSwipTableViewDelegate>

@property (nonatomic, copy) NSString * itemTitle;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) CGFloat  headerHeight;
@property (nonatomic, assign) BOOL  needScrollBlock;

@end

NS_ASSUME_NONNULL_END
