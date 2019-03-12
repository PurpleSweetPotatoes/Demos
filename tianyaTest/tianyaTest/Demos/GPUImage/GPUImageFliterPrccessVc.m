//
//  GPUImageFliterPrccessVc.m
//  tianyaTest
//
//  Created by baiqiang on 2019/1/21.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "GPUImageFliterPrccessVc.h"
#import "PhotoValueSilderVc.h"

#import <GPUImage/GPUImage.h>

#import "ImgCell.h"

@interface GPUImageFliterPrccessVc ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) UIImage * orignImg;                       ///<  原图像
@property (nonatomic, strong) UIImage * itemImg;                        ///<  原图像小图
@property (nonatomic, strong) UIImageView * showView;                   ///<  展示图
@property (nonatomic, strong) UICollectionView * collectionView;        ///<  滤镜展示
@property (nonatomic, strong) NSArray * itemsArr;                       ///<  滤镜数据源
@property (nonatomic, strong) NSMutableDictionary * dicImg;             ///<  图像缓存
@property (nonatomic, strong) GPUImageFilterGroup * groupFilters;         ///<  滤镜组(亮度、曝光度、对比度、饱和度)
@property (nonatomic, strong) GPUImageFilter * currentFilter;           ///<  当前滤镜
@property (nonatomic, assign) NSInteger  item;
@end

@implementation GPUImageFliterPrccessVc

- (instancetype)initWithImage:(UIImage *)img {
    self = [super init];
    if (self) {
        self.orignImg = img;
        self.itemImg = [UIImage imageWithImage:img scaledToSize:CGSizeMake(120, img.size.height * 120 / img.size.width)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.dicImg = [NSMutableDictionary dictionary];
    self.item = 0;
    
    [self configItemsFilter];
    
    UIImageView * cameraShowView =   [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:cameraShowView];
    self.showView = cameraShowView;

    [self updateFilter];
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.sizeW, 80)];
    topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:topView];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"item_bakc"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(30, 30, 30, 30);
    [topView addSubview:backBtn];
    
    UIButton * silderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [silderBtn addTarget:self action:@selector(silderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [silderBtn setBackgroundImage:[UIImage imageNamed:@"camera_silder"] forState:UIControlStateNormal];
    silderBtn.frame = CGRectMake(topView.center.x - 15, 30, 30, 30);
    [topView addSubview:silderBtn];
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"camera_save"] forState:UIControlStateNormal];
    saveBtn.frame = CGRectMake(topView.sizeW - 50, 30, 30, 30);
    [topView addSubview:saveBtn];
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    layout.itemSize = CGSizeMake(self.itemImg.size.width * 0.5, self.itemImg.size.height * 0.5 + 20);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 5;
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.view.sizeH - layout.itemSize.height - 6, self.view.sizeW, layout.itemSize.height + 6) collectionViewLayout:layout];
    collectionView.backgroundColor = topView.backgroundColor;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerCell:[ImgCell class] isNib:YES];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)configItemsFilter {
    
    self.currentFilter = [[GPUImageFilter alloc] init];
    self.groupFilters = [[GPUImageFilterGroup alloc] init];
    [self addGPUImageFilter:[[GPUImageBrightnessFilter alloc] init]];
    [self addGPUImageFilter:[[GPUImageExposureFilter alloc] init]];
    [self addGPUImageFilter:[[GPUImageContrastFilter alloc] init]];
    [self addGPUImageFilter:[[GPUImageSaturationFilter alloc] init]];

    self.itemsArr = @[@[@"GPUImageFilter",@"原照"],
                      @[@"GPUImageBeautifyFilter",@"美颜"],
                      @[@"GPUImageColorInvertFilter",@"反色"],
                      @[@"GPUImageSepiaFilter",@"怀旧"],
                      @[@"GPUImageLevelsFilter",@"色阶"],
                      @[@"GPUImageGrayscaleFilter",@"灰度"],
                      @[@"GPUImageRGBFilter",@"RGB"],
                      @[@"GPUImageToneCurveFilter",@"色调曲线"],
                      @[@"GPUImageMonochromeFilter",@"单色"],
                      @[@"GPUImageHighlightShadowFilter",@"提亮阴影"],
                      @[@"GPUImageFalseColorFilter",@"色彩替换"],
                      @[@"GPUImageHueFilter",@"色度"],
                      @[@"GPUImageChromaKeyFilter", @"色度键"],
                      @[@"GPUImageSharpenFilter", @"锐化"],
                      @[@"GPUImageMedianFilter",@"边缘模糊"],
                      @[@"GPUImageSketchFilter",@"素描"],
                      @[@"GPUImageToonFilter",@"卡通"],
                      @[@"GPUImageBulgeDistortionFilter",@"鱼眼效果"],
                      @[@"GPUImagePinchDistortionFilter",@"凹面镜"],
                      @[@"GPUImageStretchDistortionFilter",@"哈哈镜"],
                      @[@"GPUImageGlassSphereFilter", @"水晶球"],
                      @[@"GPUImageEmbossFilter",@"浮雕效果"]
                      ];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSArray * arr in self.itemsArr) {
            Class class = NSClassFromString(arr[0]);
            GPUImageFilter * filter = [[class alloc] init];
            self.dicImg[arr[0]] = [filter imageByFilteringImage:self.itemImg];
        }
    });
}

- (void)addGPUImageFilter:(GPUImageFilter *)filter{
    
    [self.groupFilters addFilter:filter];
    
    GPUImageOutput<GPUImageInput> *newTerminalFilter = filter;
    
    NSInteger count = self.groupFilters.filterCount;
    
    if (count == 1)
    {
        //设置初始滤镜
        self.groupFilters.initialFilters = @[newTerminalFilter];
        //设置末尾滤镜
        self.groupFilters.terminalFilter = newTerminalFilter;
        
    } else
    {
        GPUImageOutput<GPUImageInput> *terminalFilter    = self.groupFilters.terminalFilter;
        NSArray *initialFilters                          = self.groupFilters.initialFilters;
        
        [terminalFilter removeAllTargets];
        [terminalFilter addTarget:newTerminalFilter];
        
        //设置初始滤镜
        self.groupFilters.initialFilters = @[initialFilters[0]];
        //设置末尾滤镜
        self.groupFilters.terminalFilter = newTerminalFilter;
    }
}


- (void)updateFilter {
    [self addGPUImageFilter:self.currentFilter];

    self.showView.image = [self.groupFilters imageByFilteringImage:self.orignImg];
    
    //展示完毕去掉最后一个滤镜
    [self.groupFilters removeLastFilter];
    GPUImageFilter * filter = (GPUImageFilter *)[self.groupFilters filterAtIndex:3];
    [filter removeAllTargets];
    self.groupFilters.terminalFilter = filter;
}


#pragma mark - btnAction

- (void)backBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)silderBtnAction:(UIButton *)sender {
    //亮度范围[-1.0, 1.0],默认为0
    CGFloat brightness = ((GPUImageBrightnessFilter *)[self.groupFilters filterAtIndex:0]).brightness;
    //曝光度范围[-10.0, 10.0],默认为0
    CGFloat exposure = ((GPUImageExposureFilter *)[self.groupFilters filterAtIndex:1]).exposure;
    //对比度范围[0.0, 4.0],默认为1
    CGFloat contrast = ((GPUImageContrastFilter *)[self.groupFilters filterAtIndex:2]).contrast;
    //饱和度范围[0.0, 2.0],默认为1
    CGFloat saturation = ((GPUImageSaturationFilter *)[self.groupFilters filterAtIndex:3]).saturation;
    
    NSDictionary * dicInfo = @{@"brightness":@(brightness),
                               @"exposure":@(exposure),
                               @"contrast":@(contrast),
                               @"saturation":@(saturation)
                               };
    WeakSelf;
    [PhotoValueSilderVc showViewWithDictInfo:dicInfo fromVc:self proccessHandle:^(CGFloat brightness, CGFloat exposure, CGFloat contrast, CGFloat saturation) {
        ((GPUImageBrightnessFilter *)[weakSelf.groupFilters filterAtIndex:0]).brightness = brightness;
        ((GPUImageExposureFilter *)[weakSelf.groupFilters filterAtIndex:1]).exposure = exposure;
        ((GPUImageContrastFilter *)[weakSelf.groupFilters filterAtIndex:2]).contrast = contrast;
        ((GPUImageSaturationFilter *)[weakSelf.groupFilters filterAtIndex:3]).saturation = saturation;
        [weakSelf updateFilter];
    }];
}

- (void)saveBtnAction:(UIButton *)sender {
    UIImageWriteToSavedPhotosAlbum(self.showView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [BQMsgView showInfo:@"图片已保存至相册"];
    } else {
        [BQMsgView showInfo:error.localizedDescription];
    }
}

#pragma mark - CollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImgCell * cell = (ImgCell *)[collectionView loadCell:[ImgCell class] indexPath:indexPath];
    NSString * key = self.itemsArr[indexPath.row][0];
    if (self.dicImg[key]) {
        cell.imgView.image = self.dicImg[key];
    } else {
        Class class = NSClassFromString(key);
        GPUImageFilter *filter = [[class alloc] init];
        self.dicImg[key] = [filter imageByFilteringImage:self.itemImg];
        cell.imgView.image = self.dicImg[key];
    }
    cell.filterName.text = self.itemsArr[indexPath.row][1];
    cell.filterName.textColor = indexPath.item == self.item ? [UIColor greenColor] : [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    Class class = NSClassFromString(self.itemsArr[indexPath.row][0]);
    self.currentFilter = (GPUImageFilter *)[[class alloc] init];
    
    [self updateFilter];
    
    self.item = indexPath.item;
    
    [self.collectionView reloadData];
}
@end
