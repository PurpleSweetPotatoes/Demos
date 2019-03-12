//
//  PlayerListVc.m
//  tianyaTest
//
//  Created by baiqiang on 2019/1/28.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "PlayerListVc.h"
#import "AVPlayerVc.h"

#import "APIManager.h"

@interface PlayerListVc ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) NSArray * datas;
@property (nonatomic, strong) UITableView * tableView;
@end


@implementation PlayerListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configDatas];
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.tableFooterView = [UIView new];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerCell:[UITableViewCell class] isNib:NO];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.datas = @[];
}

- (void)configDatas {
    
    WeakSelf;
    [APIManager GET:kMvUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        StrongSelf;
        NSLog(@"%@",responseObject);
        strongSelf.datas = responseObject;
        [strongSelf.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark - Tablview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView loadCell:[UITableViewCell class] indexPath:indexPath];
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AVPlayerVc * playerVc = [[AVPlayerVc alloc] init];
    playerVc.movieUrl = [kMvUrl stringByAppendingPathComponent:self.datas[indexPath.row]];
    playerVc.movieTitle = self.datas[indexPath.row];
    [self.navigationController pushViewController:playerVc animated:YES];
    
}

@end
