//
//  MetroInfoSelectVc.m
//  tianyaTest
//
//  Created by baiqiang on 2019/2/23.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "MetroInfoSelectVc.h"

@interface MetroInfoSelectVc ()<
UIPickerViewDataSource,
UIPickerViewDelegate>

@property (nonatomic, strong) UIView * bottomView;

@property (nonatomic, copy) NSString * lineKey;
@property (nonatomic, copy) NSString * name;

@end

@implementation MetroInfoSelectVc


- (void)setUpUI {
    [super setUpUI];
    
    UIView * btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.sizeW, 40)];
    btnView.backgroundColor = [UIColor colorFromHexString:@"308ee3"];
    [self.bottomView addSubview:btnView];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    backBtn.frame = CGRectMake(0, 0, 80, 40);
    backBtn.tag = 0;
    [backBtn setTitle:@"返 回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:backBtn];
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    sureBtn.frame = CGRectMake(btnView.sizeW - 80, 0, 80, 40);
    sureBtn.tag = 1;
    [sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:sureBtn];
    
    
    self.lineKey = @"1";
    self.name = self.dicInfo[self.lineKey][@"names"][0];
    UIPickerView * pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, self.view.sizeW, 170)];
    pickView.dataSource = self;
    pickView.delegate = self;
    [self.bottomView addSubview:pickView];
    
    [self.view addSubview:self.bottomView];
}

- (void)animationShow {
    [super animationShow];
    [UIView animateWithDuration:self.showTime animations:^{
        self.bottomView.top -= self.bottomView.sizeH;
    }];
}

- (void)animationHide {
    [super animationHide];
    
    [UIView animateWithDuration:self.showTime animations:^{
        self.bottomView.top += self.bottomView.sizeH;
    }];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.dicInfo[@"lines"][row] stringByAppendingString:@"号线"];
    }
    return self.dicInfo[self.lineKey][@"names"][row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [self.dicInfo[@"lines"] count];
    }
    return [self.dicInfo[self.lineKey][@"names"] count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.lineKey = self.dicInfo[@"lines"][row];
        self.name = self.dicInfo[self.lineKey][@"names"][0];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:NO];
    } else {
        self.name = self.dicInfo[self.lineKey][@"names"][row];
    }
}



- (void)btnAction:(UIButton *)sender {
    if (sender.tag == 1) {
        self.objc = @{@"name":[NSString stringWithFormat:@"%@号线 %@",self.lineKey, self.name],
                      @"keyId":self.dicInfo[self.lineKey][self.name]
                      };
    }
    [self animationHide];
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.sizeH, self.view.sizeW, 210)];
        bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView = bottomView;
    }
    return _bottomView;
}


@end
