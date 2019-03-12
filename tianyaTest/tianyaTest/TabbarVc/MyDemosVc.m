//
//  ViewController.m
//  tianyaTest
//
//  Created by baiqiang on 2018/9/13.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import "MyDemosVc.h"
#import "UITableView+Custom.h"
#import "UIView+Custom.h"
#import "NSObject+Custom.h"
#import "CALayer+Custom.h"

#import "APIManager.h"

@interface MyDemosVc ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) NSArray<NSDictionary *> * dataArr;         ///<  数 据
@property (nonatomic, strong) UITableView * tableView;                   ///<  列 表

@end



@implementation MyDemosVc

- (void)testMethod {
    
}

#pragma setData

- (void)configdataArr {

    self.dataArr = @[@{kVcTitle:@"CoreText",
                       kVcName:@"AttributeStringVc"},
                     @{kVcTitle:@"Runtime",
                       kVcName:@"RunTimeTestVc"},
                     @{kVcTitle:@"GPUImage",
                       kVcName:@"GPUImageDemos"},
                     @{kVcTitle:@"PhotoKit",
                       kVcName:@"PhotoKitDemoVc"},
                     @{kVcTitle:@"TableView Cell Slider",
                       kVcName:@"SideCellVc"},
                     @{kVcTitle:@"BQTextView",
                       kVcName:@"TextViewTestVc"},
                     @{kVcTitle:@"ThreadLock",
                       kVcName:@"IOSLockVc"},
                     @{kVcTitle:@"AVPlayer",
                       kVcName:@"PlayerListVc"},
                     @{kVcTitle:@"UDP可靠传输",
                       kVcName:@"UDPLoginVc"},
                     @{kVcTitle:@"带Header的多tableView切换",
                       kVcName:@"ThroughScrollViewsVc"}
                    ];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configdataArr];
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [tableView registerCell:[UITableViewCell class] isNib:NO];
    __weak typeof(self) weakSelf = self;
    tableView.bq_headerView = [BQRefreshHeaderView headerWithBlock:^{
        [weakSelf refresh];
    }];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
   
    [self testMethod];

}

- (void)refresh {
    [self.tableView.bq_headerView beginAnimation];
    NSLog(@"刷新");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.bq_headerView endRefresh];
    });
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
    if ([className hasPrefix:@"Thr"]) {
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)noDataCanShow:(UITableView *)tableView {
    return self.dataArr.count == 0;
}

@end
