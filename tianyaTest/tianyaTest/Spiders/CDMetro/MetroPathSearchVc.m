//
//  MetroPathSearchVc.m
//  tianyaTest
//
//  Created by baiqiang on 2019/2/15.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "MetroPathSearchVc.h"
#import "MetroInfoSelectVc.h"
#import "MetroPriceRuleVc.h"

#import "MetroCell.h"

#import "APIManager.h"

@interface MetroPathSearchVc ()<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * infos;

@property (nonatomic, strong) UILabel * timeLable;
@property (nonatomic, strong) UILabel * priceLable;
@property (nonatomic, strong) UILabel * distanceLable;

@property (nonatomic, copy) NSString * fromId;
@property (nonatomic, copy) NSString * toId;

@property (nonatomic, strong) NSDictionary * priceRuleInfo;
/*
 
 */
@property (nonatomic, strong) NSDictionary * lineDicInfos;

@end

@implementation MetroPathSearchVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self setUpUI];
}


- (void)setUpUI {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"说明" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemAction:)];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, KNavBottom, self.view.sizeW, 160)];
    headerView.clipsToBounds = YES;
    headerView.sizeH = 100;
    headerView.backgroundColor = [UIColor colorFromHexString:@"308ee3"];
    [self.view addSubview:headerView];
    self.headerView = headerView;
    [self configHeaderView];
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.bottom, self.view.sizeW, self.view.sizeH - headerView.bottom)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerCell:[MetroCell class] isNib:YES];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 44;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)configHeaderView {
    CGFloat originY = 20;
    [self configLineInfoBtn:originY title:@"起点" tag:0];
    [self configLineInfoBtn:originY + 40 title:@"终点" tag:1];
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(self.view.sizeW - 80,originY + 20, 60, 40);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    searchBtn.layer.borderWidth = 1.0;
    searchBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [searchBtn setTitle:@"查 询" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:searchBtn];
    
    
    self.timeLable = [self configSearchInfoLabel:CGRectMake(20, 100, (self.view.sizeW - 40) * 0.5, 50)];
    self.timeLable.font = [UIFont systemFontOfSize:20];
        
    self.priceLable = [self configSearchInfoLabel:CGRectMake(self.timeLable.right, self.timeLable.top, self.timeLable.sizeW ,25)];
    
    self.distanceLable = [self configSearchInfoLabel:self.priceLable.frame];
    self.distanceLable.top = self.priceLable.bottom;

}

- (UILabel *)configSearchInfoLabel:(CGRect)frame {
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    [self.headerView addSubview:label];
    return label;
}

- (void)configLineInfoBtn:(CGFloat)originY title:(NSString *)title tag:(NSInteger)tag {
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, originY, 100, 1)];
    titleLab.text = title;
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = [UIColor whiteColor];
    [titleLab widthToFit];
    titleLab.sizeH = 30;
    [self.headerView addSubview:titleLab];
    
    UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(titleLab.right + 20,originY, self.headerView.sizeW - titleLab.right - 120, titleLab.sizeH);
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    selectBtn.layer.borderWidth = 1.0;
    selectBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    selectBtn.layer.cornerRadius = selectBtn.sizeH * 0.5;
    selectBtn.tag = tag;
    [selectBtn setTitle:@"---点击选择---" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:selectBtn];
}

#pragma mark - Btn Action

- (void)selectBtnAction:(UIButton *)sender {
    [MetroInfoSelectVc showViewWihtDictInfo:self.lineDicInfos fromVc:self handle:^(NSDictionary * dict) {
        if (sender.tag == 0) {
            self.fromId = dict[@"keyId"];
        } else {
            self.toId = dict[@"keyId"];
        }
        [sender setTitle:dict[@"name"] forState:UIControlStateNormal];
    }];
}

- (void)searchBtnAction:(UIButton *)sender {
    if ([self.fromId isEqualToString:self.toId]) {
        return;
    }
    
    [BQActivityView showActiviTy];
    [APIManager GET:kMetroPathSearchUrl parameters:@{@"from": self.fromId, @"to": self.toId} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [BQActivityView hideActiviTy];
        self.priceLable.text = [NSString stringWithFormat:@"价格 %@ 元", responseObject[@"price"]];
        self.timeLable.text = [NSString stringWithFormat:@"预估: %@ 分钟", responseObject[@"minute"]];
        self.distanceLable.text = [NSString stringWithFormat:@"距离 %@ 公里", responseObject[@"distance"]];
        self.infos = responseObject[@"infos"];
        
        self.headerView.sizeH = 160;
        self.tableView.top = self.headerView.bottom;
        self.tableView.sizeH = self.view.sizeH - self.headerView.bottom;
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
        [BQActivityView hideActiviTy];
    }];
    
}

- (void)rightBarItemAction:(UIBarButtonItem *)sender {
    [MetroPriceRuleVc showViewWihtDictInfo:self.priceRuleInfo fromVc:self handle:nil];
}

#pragma mark - NetWork

- (void)loadData {
    [BQActivityView showActiviTy];
    WeakSelf;
    [APIManager GET:kMetroInfoUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [BQActivityView hideActiviTy];
        StrongSelf;
        [strongSelf proccessResponseInfo:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [BQActivityView hideActiviTy];
        NSLog(@"%@",error.localizedDescription);
    }];
    
    [APIManager GET:kMetroPriceRuleUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.priceRuleInfo = responseObject;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)proccessResponseInfo:(NSDictionary *)response {
    if ([response[@"stations"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary * lineDic = response[@"stations"];
        NSArray * lines = [lineDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
            return [obj1 integerValue] > [obj2 integerValue];
        }];
        
        NSMutableDictionary * infoDic = [NSMutableDictionary dictionaryWithCapacity:lines.count + 1];
        infoDic[@"lines"] = lines;
        
        for (NSString * lineStr in lines) {
            NSDictionary * lineInfos = lineDic[lineStr];
            
            NSArray * keys = [lineInfos.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
                return [obj1 integerValue] > [obj2 integerValue];
            }];
            
            NSMutableDictionary * sortInfos = [NSMutableDictionary dictionaryWithCapacity:lineDic.allKeys.count];
            NSMutableArray * names = [NSMutableArray arrayWithCapacity:lineDic.allKeys.count];
        
            for (NSString * key in keys) {
                [names addObject:lineInfos[key]];
                sortInfos[lineInfos[key]] = key;
            }
            sortInfos[@"names"] = names;
            
            infoDic[lineStr] = sortInfos;
        }

        self.lineDicInfos = infoDic;
    }
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MetroCell * cell = (MetroCell *)[tableView loadCell:[MetroCell class] indexPath:indexPath];
    [cell configInfo:self.infos[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infos.count;
}


@end
