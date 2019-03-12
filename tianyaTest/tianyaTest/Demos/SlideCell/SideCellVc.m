//
//  SideCellVc.m
//  tianyaTest
//
//  Created by baiqiang on 2019/1/19.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "SideCellVc.h"

#import "SideCell.h"

@interface SideCellVc ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) NSArray<UITableViewRowAction *> * actionArr;         ///<  cell侧滑后的菜单
@end

@implementation SideCellVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 50;
    tableView.tableFooterView = [[UIView alloc] init];
    [tableView registerCell:[SideCell class] isNib:YES];
    [tableView registerCell:[UITableViewCell class] isNib:NO];
    
    [self.view addSubview:tableView];
    
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SideCell * cell = (SideCell *)[tableView loadCell:[SideCell class] indexPath:indexPath];
        
        return cell;
    }
    
    UITableViewCell * cell = [tableView loadCell:[UITableViewCell class] indexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor randomColor];
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"自定义左右滑动";
    }
    return @"系统左右滑动";
}


- (void)tableViewSwipWithAction:(UITableViewRowAction *)action indexPath:(NSIndexPath *)indexpath {
    NSLog(@"%@ at %d",action.title, indexpath.row);
}

#pragma mark - UITableViewCell Method Of Edit

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1;
}


- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.actionArr;
}


- (NSArray<UITableViewRowAction *> *)actionArr {
    if (_actionArr == nil) {
        NSMutableArray * actionArr = [NSMutableArray arrayWithCapacity:3];
        NSArray * titles = @[@"已读", @"置顶", @"删除"];
        WeakSelf;
        for (NSString * title in titles) {
            UITableViewRowAction * action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                StrongSelf;
                [strongSelf tableViewSwipWithAction:action indexPath:indexPath];
            }];
            action.backgroundColor = RandomColor;
            if ([title isEqualToString:@"删除"]) {
//                UIColor * imgColor = [UIColor c]
            }
            
            [actionArr addObject:action];
        }
        _actionArr = actionArr;
    }
    return _actionArr;
}

@end
