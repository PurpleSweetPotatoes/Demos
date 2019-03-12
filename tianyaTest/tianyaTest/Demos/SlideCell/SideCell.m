//
//  SideCell.m
//  tianyaTest
//
//  Created by baiqiang on 2019/1/19.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "SideCell.h"

static const CGFloat kMaxOffset = 150;

@interface SideCell()
@property (nonatomic, assign) CGFloat startPointX;         ///<  拖拽起点x
@property (nonatomic, strong) UIView * backView;         ///<  背景视图
@end

@implementation SideCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    self.backView.backgroundColor = [UIColor randomColor];
    [self.contentView addSubview:self.backView];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self addGestureRecognizer:pan];
    
}

#pragma mark - GestureAction

- (void)panGestureAction:(UIPanGestureRecognizer *) sender {
    CGPoint point = [sender locationInView:self];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"拖拽开始");
        self.startPointX = point.x;
    } else if (sender.state == UIGestureRecognizerStateChanged){
        NSLog(@"拖拽移动");
        if (fabs(self.startPointX - point.x) > kMaxOffset) {
            self.backView.frame = CGRectMake(point.x - self.startPointX > kMaxOffset ? kMaxOffset:-kMaxOffset, 0, self.sizeW, self.sizeH);
        } else {
            self.backView.frame = CGRectMake(point.x - self.startPointX, 0, self.sizeW, self.sizeH);
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        NSLog(@"拖拽结束");
        [UIView animateWithDuration:0.25 animations:^{
            self.backView.frame = CGRectMake(0, 0, self.sizeW, self.sizeH);
        }];
    }

}

@end
