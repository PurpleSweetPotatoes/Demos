//
//  MetroDescVc.m
//  tianyaTest
//
//  Created by baiqiang on 2019/3/9.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "MetroPriceRuleVc.h"

@interface MetroPriceRuleVc ()
<
UITableViewDataSource
>
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation MetroPriceRuleVc

- (void)setUpUI {
    [super setUpUI];
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KScreenHeight, self.view.sizeW, self.view.sizeH - KNavBottom) style:UITableViewStylePlain];
    tableView.tableHeaderView = [self configTableViewHeaderView];
    tableView.bounces = NO;
    tableView.backgroundColor = [UIColor colorFromHexString:@"308ee3"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.rowHeight = 40;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

- (UIView *)configTableViewHeaderView {
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.sizeW, 0)];
    UILabel * descLab = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, headerView.sizeW - 16, 0)];
    descLab.numberOfLines = 0;
    descLab.textColor = [UIColor whiteColor];
    descLab.text = self.dicInfo[@"Desc"];
    descLab.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    [descLab heightToFit];
    [headerView addSubview:descLab];
    
    UIView * bgView = [[UILabel alloc] initWithFrame:CGRectMake(0, descLab.bottom + 8, headerView.sizeW, 40)];
    [headerView addSubview:bgView];
    
    NSArray * titles = @[@"里程范围", @"跨度", @"单程票价"];
    CGFloat labWidth = headerView.sizeW / 3;
    for (NSInteger i = 0; i < titles.count; i++) {
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(i * labWidth, 0, labWidth, bgView.sizeH)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = titles[i];
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:lab];
    }
    
    headerView.sizeH = bgView.bottom;
    return headerView;
}

- (void)animationShow {
    [super animationShow];
    [UIView animateWithDuration:self.showTime animations:^{
        self.tableView.top = KNavBottom;
    }];
}

- (void)animationHide {
    [super animationHide];
    [UIView animateWithDuration:self.showTime animations:^{
        self.tableView.top = KScreenHeight;
    }];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dicInfo[@"list"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorFromHexString:@"308ee3"];
        CGFloat labWidth = self.view.sizeW / 3;
        for (NSInteger i = 0; i < 3; i++) {
            UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(i * labWidth, 0, labWidth, 40)];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor whiteColor];
            lab.font = [UIFont systemFontOfSize:15];
            lab.tag = 100 + i;
            [cell.contentView addSubview:lab];
        }
    }
    NSDictionary * info = self.dicInfo[@"list"][indexPath.row];
    
    UILabel * rangeLab = [cell.contentView viewWithTag:100];
    rangeLab.text = info[@"range"];
    
    UILabel * lengthLab = [cell.contentView viewWithTag:101];
    lengthLab.text = info[@"length"];
    
    UILabel * priceLab = [cell.contentView viewWithTag:102];
    priceLab.text = info[@"price"];
    
    return cell;
}
@end
