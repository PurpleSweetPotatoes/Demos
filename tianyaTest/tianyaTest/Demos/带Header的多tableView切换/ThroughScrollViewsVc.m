//
//  ThroughScrollViewsVc.m
//  tianyaTest
//
//  Created by baiqiang on 2019/3/12.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "ThroughScrollViewsVc.h"
#import "TableVc.h"

@interface ThroughScrollViewsVc ()
@property (nonatomic, strong) BQSwipeSubTableVc * swipVc;
@end

@implementation ThroughScrollViewsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BQSwipeSubTableVc * swipVc = [[BQSwipeSubTableVc alloc] init];
    swipVc.navBottom = self.navigationController ? KNavBottom : 0;
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.sizeW, 15 * self.view.sizeW / 24)];
    imgView.image = [UIImage imageNamed:@"1.jpg"];
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [imgView addGestureRecognizer:tap];
    swipVc.headerView = imgView;
    
    UIView * barView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.sizeW, 44)];
    barView.backgroundColor = [UIColor cyanColor];
    
    NSArray * arr = @[@"iOS", @"Python" , @"C", @"C++"];
    CGFloat btnWidth = self.view.sizeW / arr.count;
    NSMutableArray * tabArrs = [NSMutableArray arrayWithCapacity:arr.count];
    for (NSInteger i = 0; i < arr.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnWidth * i, 0, btnWidth, barView.sizeH);
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:btn];
        
        TableVc * tabVc = [[TableVc alloc] init];
        tabVc.itemTitle = arr[i];
        [tabArrs addObject:tabVc];
    }
    
    swipVc.barView = barView;
    
    swipVc.tabArrs = tabArrs;
    WeakSelf;
    [swipVc tabVcWillSwitchToIndex:^(NSInteger index) {
        StrongSelf;
        [strongSelf changeToIndex:index];
    }];
    
    [self.view addSubview:swipVc.view];
    [self addChildViewController:swipVc];
    self.swipVc = swipVc;
}

- (void)changeToIndex:(NSInteger)index {
    NSLog(@"跳转到第%ld个tableView",index);
}

#pragma mark - Btn Action

- (void)btnAction:(UIButton *)sender {
    NSLog(@"点击第%ld个",sender.tag);
    [self.swipVc switchToTabVc:sender.tag];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)sender {
    NSLog(@"广告位点击");
}
@end
