//
//  MetroCell.m
//  tianyaTest
//
//  Created by baiqiang on 2019/2/23.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "MetroCell.h"

@interface MetroCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (nonatomic, strong) CAShapeLayer * topLine;
@property (nonatomic, strong) CAShapeLayer * bottomLine;
@end

@implementation MetroCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CAShapeLayer * centerLayer = [CAShapeLayer layer];
    centerLayer.frame = CGRectMake(21, 18, 8, 8);
    centerLayer.borderColor = [UIColor lightGrayColor].CGColor;
    centerLayer.borderWidth = 1;
    centerLayer.cornerRadius = 4;
    [self.contentView.layer addSublayer:centerLayer];
    
    CAShapeLayer * topLayer = [CAShapeLayer layer];
    topLayer.frame = CGRectMake(24.5, 0, 1, 18);
    topLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.contentView.layer addSublayer:topLayer];
    self.topLine = topLayer;
    
    CAShapeLayer * bottomLayer = [CAShapeLayer layer];
    bottomLayer.frame = CGRectMake(24.5, 26, 1, 18);
    bottomLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.contentView.layer addSublayer:bottomLayer];
    self.bottomLine = bottomLayer;
    
    self.nameLab.frame = CGRectMake(35, 10, 100, 24);
    self.statusLab.frame = CGRectMake(35, 14, 100, 16);
    
    self.timeLab.frame = CGRectMake(KScreenWidth - 120, 10, 100, 20);
    self.statusLab.layer.cornerRadius = 8;
    self.statusLab.clipsToBounds = YES;
    self.statusLab.backgroundColor = [UIColor colorFromHexString:@"308ee3"];
}

- (void)configInfo:(NSDictionary *)info {

    self.statusLab.hidden = NO;
    self.topLine.hidden = NO;
    self.bottomLine.hidden = NO;
    
    self.statusLab.text = info[@"status"];
    
    
    
    self.timeLab.text = [info[@"time"] stringByAppendingString:@"分钟"];
    
    if ([info[@"status"] isEqualToString:@""]) {
        self.nameLab.text = info[@"name"];
        self.statusLab.hidden = YES;
    } else if ([info[@"status"] isEqualToString:@"起始点"]) {
        self.nameLab.text = [NSString stringWithFormat:@"%@ (%@号线)",info[@"name"], info[@"line"]];
        self.topLine.hidden = YES;
    } else if ([info[@"status"] isEqualToString:@"换乘站"]) {
        self.nameLab.text = [NSString stringWithFormat:@"%@ (换乘%@号线)",info[@"name"], info[@"line"]];
    } else if ([info[@"status"] isEqualToString:@"终点"]) {
        self.bottomLine.hidden = YES;
        self.nameLab.text = info[@"name"];
    }
    
    [self.nameLab widthToFit];
    self.nameLab.sizeW += 10;
    
    [self.statusLab widthToFit];
    self.statusLab.sizeW += 10;
    self.statusLab.left = self.nameLab.right;
}

@end
