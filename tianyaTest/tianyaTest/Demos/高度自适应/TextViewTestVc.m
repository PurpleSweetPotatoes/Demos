//
//  TextViewTestVc.m
//  tianyaTest
//
//  Created by baiqiang on 2018/9/13.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import "TextViewTestVc.h"
#import "BQTextView.h"
#import "UIView+Custom.h"
#import <YYTextView.h>

@interface TextViewTestVc ()
<
YYTextViewDelegate
>
@property (nonatomic, strong) YYTextView * textView;         ///<  多行输入视图
@end

@implementation TextViewTestVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.textView = [[YYTextView alloc] initWithFrame:CGRectMake(100, 100, 150, 40)];
//    self.textView.delegate = self;
//    self.textView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:self.textView];
//
    BQTextView * textView = [[BQTextView alloc] initWithFrame:CGRectMake(100, 200, 150, 22)];
    textView.placeholder = @"this is test";
    textView.placeholderColor = [UIColor grayColor];
    textView.autoAdjustHeight = YES;
    textView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:textView];
}



- (BOOL)textView:(YYTextView *)textView shouldTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange {
    return YES;
}

@end
