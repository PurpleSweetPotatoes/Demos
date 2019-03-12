//
//  MyHelperVc.m
//  tianyaTest
//
//  Created by baiqiang on 2019/2/15.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "MySpiderVc.h"

@interface MySpiderVc ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) NSArray<NSDictionary *> * dataArr;         ///<  数据
@property (nonatomic, strong) UITableView * tableView;         ///<  列表

@end



@implementation MySpiderVc

#pragma setData

- (void)configdataArr {
    
    self.dataArr = @[@{kVcTitle:@"地铁路线查询",
                       kVcName:@"MetroPathSearchVc"},
                     ];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configdataArr];
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [tableView registerCell:[UITableViewCell class] isNib:NO];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self testMethod];
}

- (void)testMethod {
    
}


#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView loadCell:[UITableViewCell class] indexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArr[indexPath.row][kVcTitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString * className = self.dataArr[indexPath.row][kVcName];
    
    Class class = NSClassFromString(className);
    UIViewController * vc = [[class alloc] init];
    vc.title = self.dataArr[indexPath.row][kVcTitle];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
