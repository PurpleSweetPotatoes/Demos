//
//  TableVc.m
//  tianyaTest
//
//  Created by baiqiang on 2019/3/12.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "TableVc.h"

@interface TableVc ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) NSArray * datas;
@property (nonatomic, copy) void(^callBlock)(CGFloat y);
@end

@implementation TableVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.datas = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.sizeW, self.headerHeight)];
    tableView.tableHeaderView = headerView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerCell:[UITableViewCell class] isNib:NO];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)reloadWithDatas:(NSArray *)datas {
    self.datas = datas;
    [self.tableView reloadData];
}

- (void)scrollViewDidScrollBlock:(void (^)(CGFloat offsetY))block {
    self.callBlock = block;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView loadCell:[UITableViewCell class] indexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%ld行", self.itemTitle, indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.needScrollBlock && self.callBlock) {
        self.callBlock(scrollView.contentOffset.y);
    }
}

@end
