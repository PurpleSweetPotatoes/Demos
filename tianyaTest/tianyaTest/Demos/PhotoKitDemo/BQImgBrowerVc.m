//
//  BQImgBrowerVc.m
//  tianyaTest
//
//  Created by baiqiang on 2019/1/8.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "BQImgBrowerVc.h"

@interface BQImgBrowerVc ()

@property (nonatomic, strong) NSArray * assetArr;         ///<  asset数据源

@end

@implementation BQImgBrowerVc


- (instancetype)initWithAssets:(NSArray<PHAsset *> *)assetArr {
    
    self = [super init];
   
    if (self) {
        _assetArr = assetArr;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
}



@end
