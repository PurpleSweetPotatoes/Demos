//
//  AttributeStringVc.m
//  tianyaTest
//
//  Created by baiqiang on 2018/10/10.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import "AttributeStringVc.h"

#import "BQDisplayView.h"
#import "CTFrameParserConfig.h"
#import "CTFrameParser.h"

@interface AttributeStringVc ()

@end

@implementation AttributeStringVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    BQDisplayView *displayView = [[BQDisplayView alloc] initWithFrame:CGRectMake(10, 80, self.view.bounds.size.width - 20, 0)];
    
    //配置文本属性信息
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.width = displayView.bounds.size.width;
    config.textColor = [UIColor orangeColor];
    
    //得到视图文本数据
    NSString * path = [[NSBundle mainBundle] pathForResource:@"NetWorkData" ofType:@"plist"];
    displayView.data = [CTFrameParser parseTemplateFile:path config:config];
    
    
    [self.view addSubview:displayView];
}



@end
