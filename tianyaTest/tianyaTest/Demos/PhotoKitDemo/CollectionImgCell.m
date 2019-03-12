//
//  CollectionImgCell.m
//  tianyaTest
//
//  Created by baiqiang on 2019/1/4.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "CollectionImgCell.h"

@interface CollectionImgCell()
@property (nonatomic, assign) CGFloat targetWidth;         ///<  获取的宽度
@property (nonatomic, strong) PHImageRequestOptions * options;
@end



@implementation CollectionImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.options = [[PHImageRequestOptions alloc] init];
    self.targetWidth = self.imgView.sizeW * [UIScreen mainScreen].scale;
}

- (IBAction)markBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.assetModel.selected = sender.selected;
}

- (void)setAssetModel:(PHAsset *)assetModel {
    _assetModel = assetModel;
    self.markBtn.selected = assetModel.selected;
    self.imgView.image = nil;
    
    [[PHImageManager defaultManager] requestImageForAsset:assetModel targetSize:CGSizeMake(self.targetWidth, self.targetWidth) contentMode:PHImageContentModeDefault options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.imgView.image = result;
    }];
}

@end
