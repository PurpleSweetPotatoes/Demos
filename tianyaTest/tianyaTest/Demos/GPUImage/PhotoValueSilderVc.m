//
//  PhotoValueSilderVc.m
//  tianyaTest
//
//  Created by baiqiang on 2019/1/22.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "PhotoValueSilderVc.h"

typedef NS_ENUM(NSUInteger, SilderTag) {
    SilderTag_Brightness = 100,   //亮度
    SilderTag_Exposure,     //曝光度
    SilderTag_Contrast,     //对比度
    SilderTag_Saturation    //饱和度
};

@interface PhotoValueSilderVc ()
@property (nonatomic, strong) void(^proccessBlock)(CGFloat brightness, CGFloat exposure, CGFloat contrast, CGFloat saturation);
@property (nonatomic, strong) UIView * topView;         ///<  上部视图
@end



@implementation PhotoValueSilderVc

+ (void)showViewWithDictInfo:(NSDictionary *)dicInfo fromVc:(UIViewController *)fromVc proccessHandle:(void(^)(CGFloat brightness, CGFloat exposure, CGFloat contrast, CGFloat saturation))proccessHandle {
    PhotoValueSilderVc * silderVc = [self showViewWihtDictInfo:dicInfo fromVc:fromVc handle:nil];
    silderVc.proccessBlock = proccessHandle;
    silderVc.dicInfo = dicInfo;
}

- (void)animationShow {
    [super animationShow];
    [UIView animateWithDuration:self.showTime animations:^{
        self.topView.alpha = 1;
    }];
}

- (void)animationHide {
    [super animationHide];
    [UIView animateWithDuration:self.hideTime animations:^{
        self.topView.alpha = 0;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needBackView = NO;
    
    NSArray * silderInfos = @[@[@"亮度",self.dicInfo[@"brightness"],@(-1.0),@(1.0)],
                             @[@"曝光度",self.dicInfo[@"exposure"],@(-10.0),@(10.0)],
                             @[@"对比度",self.dicInfo[@"contrast"],@(0),@(4.0)],
                             @[@"饱和度",self.dicInfo[@"saturation"],@(0),@(2.0)],
                             ];
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, self.view.sizeW, 80)];
    topView.alpha = 0;
    topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:topView];
    self.topView = topView;
    
    NSInteger index = 0;
    for (NSArray * infoArr in silderInfos) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, index * 20, 80, 20)];
        label.text = infoArr[0];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor whiteColor];
        [topView addSubview:label];
        
        UISlider * slider = [[UISlider alloc] initWithFrame:CGRectMake(label.right + 10, label.top, 200, 20)];
        [slider setThumbImage:[UIImage imageNamed:@"tumbImg"] forState:UIControlStateNormal];
        slider.minimumValue = [infoArr[2] floatValue];
        slider.maximumValue = [infoArr[3] floatValue];
        slider.value = [infoArr[1] floatValue];
        slider.tag = index + SilderTag_Brightness;
        [slider addTarget:self action:@selector(sliderValueChangeAction:) forControlEvents:UIControlEventValueChanged];
        [topView addSubview:slider];
        
        index++;
    }
    
    UIButton * resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetBtn.frame = CGRectMake(300, 20, 50, 40);
    [resetBtn setTitle:@"复位" forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(resetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:resetBtn];
    
}


- (void)sliderValueChangeAction:(UISlider *)sender {
    UISlider *slider = [self.topView viewWithTag:SilderTag_Brightness];
    CGFloat brightness = slider.value;
    
    slider = [self.topView viewWithTag:SilderTag_Exposure];
    CGFloat exposure = slider.value;
    
    slider = [self.topView viewWithTag:SilderTag_Contrast];
    CGFloat contrast = slider.value;
    
    
    slider = [self.topView viewWithTag:SilderTag_Saturation];
    CGFloat saturation = slider.value;
    
    if (self.proccessBlock) {
        self.proccessBlock(brightness, exposure, contrast, saturation);
    }
}

- (void)resetBtnAction:(UIButton *)sender {
    
    UISlider *slider = [self.topView viewWithTag:SilderTag_Brightness];
    slider.value = 0;
    
    slider = [self.topView viewWithTag:SilderTag_Exposure];
    slider.value = 0;
    
    slider = [self.topView viewWithTag:SilderTag_Contrast];
    slider.value = 1;
    
    slider = [self.topView viewWithTag:SilderTag_Saturation];
    slider.value = 1;
    
    if (self.proccessBlock) {
        self.proccessBlock(0, 0, 1, 1);
    }
}

@end
