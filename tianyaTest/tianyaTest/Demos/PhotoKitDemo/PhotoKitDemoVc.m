//
//  PhotoKitDemoVc.m
//  tianyaTest
//
//  Created by baiqiang on 2019/1/4.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "PhotoKitDemoVc.h"
#import "CollectionImgCell.h"

#import <objc/runtime.h>
/*  使用相册需在info.plist文件中添加NSPhotoLibraryUsageDescription字段 */
@interface PhotoKitDemoVc ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) UICollectionView * collectionView;         ///<  列表视图
@property (nonatomic, strong) NSMutableArray<PHAsset *> * datasArr;         ///<  数据源
@end

@implementation PhotoKitDemoVc

- (void)dealloc {
    NSLog(@"%@ 被释放了",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.datasArr = [NSMutableArray array];
    
    [self checkPhotoAuthor];
    
    [self setupUI];
}

- (void)setupUI {
    
    NSInteger lineNum = 4;
    CGFloat spacing = 2;
    CGFloat itemW = floor((self.view.sizeW - spacing * 2) / lineNum);
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(spacing, spacing, 0, spacing);
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KNavBottom, self.view.sizeW, self.view.sizeH - KNavBottom) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerCell:[CollectionImgCell class] isNib:YES];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
}

#pragma mark - CollectionView method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionImgCell * imgCell = (CollectionImgCell *)[collectionView loadCell:[CollectionImgCell class] indexPath:indexPath];
    
    imgCell.assetModel = self.datasArr[indexPath.item];
    
    return imgCell;
}

#pragma mark - Photo image method

- (void)checkPhotoAuthor {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            NSLog(@"已验证");
            [self getAllPhoto];
        } else {
            NSLog(@"未验证");
        }
    }];
}

- (void)getAllPhoto {
    
    // 列出所有相册智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    for (PHAssetCollection *albums in smartAlbums) {
        NSLog(@"%@",albums.localizedTitle);
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:albums options:nil];
        for (PHAsset * asset in assets) {
            [self.datasArr addObject:asset];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

@end

@implementation PHAsset(Selected)

const char kSelect;

- (void)setSelected:(BOOL)selected {
    NSNumber * num = selected ? @(1):@(0);
    objc_setAssociatedObject(self, &kSelect, num, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)selected {
    NSNumber * num = objc_getAssociatedObject(self, &kSelect);
    return [num boolValue];
}

@end


