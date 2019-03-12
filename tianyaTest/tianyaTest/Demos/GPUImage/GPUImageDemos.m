//
//  GPUImageDemos.m
//  tianyaTest
//
//  Created by baiqiang on 2018/12/28.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import "GPUImageDemos.h"
#import "GPUImageFliterPrccessVc.h"

#import <GPUImage/GPUImage.h>
#import "GPUImageBeautifyFilter.h"
typedef NS_ENUM(NSUInteger, CameraModelBtnType) {
    CameraModelBtnType_Auto = 100,
    CameraModelBtnType_Open,
    CameraModelBtnType_Close,
};

@interface GPUImageDemos ()
<CAAnimationDelegate>
@property (nonatomic, strong) GPUImageStillCamera * camera;
@property (nonatomic, strong) GPUImageMovieWriter * movieWriter;        ///<  视频录制对象
@property (nonatomic, strong) GPUImageView * cameraShowView;            ///< 输出视图展示
@property (nonatomic, strong) CALayer * foucsLayer;                     ///<  聚焦框

@property (nonatomic, strong) GPUImageFilter * filter;                  ///<  拍照使用滤镜
@property (nonatomic, strong) UIView  * photoBottomView;                ///<  拍照底部视图
@property (nonatomic, strong) UIView  * videoBottomView;                ///<  录像底部视图
@property (nonatomic, copy) NSString * movieUrlStr;                     ///<  录制视频路径
@property (nonatomic, strong) UIButton * videoBtn;                      ///<  录像按钮
@property (nonatomic, strong) UIButton * flashBtn;                      ///<  闪光灯按钮
@property (nonatomic, strong) UIButton * torchBtn;                      ///<  手电筒按钮
@property (nonatomic, strong) UIView * lightModelView;                  ///<  光源选择图
@property (nonatomic, assign) CGFloat currentZoom;                      ///<  当前焦距比例
@end

@implementation GPUImageDemos

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setGPUCamera];
    
    [self setUpUI];
    
    [self addGestures];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.camera startCameraCapture];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.movieWriter cancelRecording];
    self.videoBtn.selected = NO;
    [self.camera stopCameraCapture];
}

- (void)dealloc {
    NSLog(@"%@被释放了",self);
}


- (void)setGPUCamera {
    
    GPUImageStillCamera * stillImgCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
    stillImgCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.camera = stillImgCamera;
    self.camera.horizontallyMirrorFrontFacingCamera = YES;
    
    GPUImageView * cameraShowView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 64,self.view.frame.size.width,self.view.frame.size.height - 64)];
    [cameraShowView setInputRotation:kGPUImageFlipHorizonal atIndex:0];
    cameraShowView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview:cameraShowView];
    
    [stillImgCamera addTarget:cameraShowView];
    
    self.filter = [[GPUImageFilter alloc] init];
//    self.filter = [[GPUImageBeautifyFilter alloc] init];
    [self.camera addTarget:self.filter];
    self.currentZoom = 1;
}

// GPUImageMovieWriter无法连续两次录制, 这个太坑了。另外大小要为480*640就不会有奇怪现象
- (void)updateMovieWrite {
    [self.filter removeTarget:self.movieWriter];
    self.movieUrlStr = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([self.movieUrlStr UTF8String]);
    GPUImageMovieWriter * writer = [[GPUImageMovieWriter alloc] initWithMovieURL:[NSURL fileURLWithPath:self.movieUrlStr] size:CGSizeMake(480.0, 800.0)];
    writer.encodingLiveVideo = YES;
    self.movieWriter = writer;
    [self.filter addTarget:self.movieWriter];
    self.camera.audioEncodingTarget = self.movieWriter;
}

- (void)setUpUI {
    
    UIButton * topRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    topRightBtn.bounds = CGRectMake(0, 0, 30, 30);
    [topRightBtn setBackgroundImage:[UIImage imageNamed:@"camera_video"] forState:UIControlStateNormal];
    [topRightBtn setBackgroundImage:[UIImage imageNamed:@"camera_photo"] forState:UIControlStateSelected];
    [topRightBtn addTarget:self action:@selector(topRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:topRightBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    [self setUpPhotoBottomView];
    [self setUpVideoBottomView];
}

- (void)setUpPhotoBottomView {
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.sizeH - 80, self.view.sizeW, 80)];
    bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:bottomView];
    self.photoBottomView = bottomView;
    
    UIButton * photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoBtn addTarget:self action:@selector(photoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"camera_take_photo"] forState:UIControlStateNormal];
    photoBtn.frame = CGRectMake(0, 0, 50, 50);
    photoBtn.center = CGPointMake(self.view.sizeW * 0.5, bottomView.sizeH * 0.5);
    [bottomView addSubview:photoBtn];
    
    UIButton * flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashBtn addTarget:self action:@selector(flashBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    flashBtn.frame = photoBtn.frame;
    flashBtn.center = CGPointMake(self.view.sizeW * 0.25 - 20, bottomView.sizeH * 0.5);
    [bottomView addSubview:flashBtn];
    self.flashBtn = flashBtn;
    [self loadImgInBtn:flashBtn];

    
    UIButton * rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotateBtn addTarget:self action:@selector(rotateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [rotateBtn setImage:[UIImage imageNamed:@"camera_rotate"] forState:UIControlStateNormal];
    rotateBtn.frame = photoBtn.frame;
    rotateBtn.center = CGPointMake(self.view.sizeW * 0.75 + 20, bottomView.sizeH * 0.5);
    [bottomView addSubview:rotateBtn];
}

- (void)setUpVideoBottomView {
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.sizeH - 80, self.view.sizeW, 80)];
    bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    bottomView.hidden = YES;
    [self.view addSubview:bottomView];
    self.videoBottomView = bottomView;
    
    UIButton * videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [videoBtn addTarget:self action:@selector(videoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [videoBtn setBackgroundImage:[UIImage imageNamed:@"camera_start_video"] forState:UIControlStateNormal];
    [videoBtn setBackgroundImage:[UIImage imageNamed:@"camera_stop_video"] forState:UIControlStateSelected];
    videoBtn.frame = CGRectMake(0, 0, 50, 50);
    videoBtn.center = CGPointMake(self.view.sizeW * 0.5, bottomView.sizeH * 0.5);
    [bottomView addSubview:videoBtn];
    self.videoBtn = videoBtn;
    
    UIButton * torchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [torchBtn addTarget:self action:@selector(torchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    torchBtn.frame = videoBtn.frame;
    torchBtn.center = CGPointMake(self.view.sizeW * 0.25 - 20, bottomView.sizeH * 0.5);
    [bottomView addSubview:torchBtn];
    self.torchBtn = torchBtn;
    [self loadImgInBtn:torchBtn];
    
    
    UIButton * rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotateBtn addTarget:self action:@selector(rotateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [rotateBtn setImage:[UIImage imageNamed:@"camera_rotate"] forState:UIControlStateNormal];
    rotateBtn.frame = videoBtn.frame;
    rotateBtn.center = CGPointMake(self.view.sizeW * 0.75 + 20, bottomView.sizeH * 0.5);
    [bottomView addSubview:rotateBtn];
    
    //录制时长
//    UILabel * timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    timeLab.textColor = [UIColor whiteColor];
//    timeLab.text = @"00:00:00";
//    timeLab.textAlignment = NSTextAlignmentCenter;
//    timeLab.font = [UIFont systemFontOfSize:14];
//    timeLab.center = CGPointMake(self.view.sizeW * 0.75 + 20, bottomView.sizeH * 0.5);
//    [bottomView addSubview:timeLab];
}

- (void)addGestures {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturAction:)];
    [self.view addGestureRecognizer:tap];
    
    UIPinchGestureRecognizer * pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinGestureAction:)];
    [self.view addGestureRecognizer:pin];
}

- (void)showCameralightModelView {
    if (!self.lightModelView.hidden) {
        self.lightModelView.hidden = YES;
        return;
    }
    
    if (self.camera.inputCamera.hasFlash) {
        self.lightModelView.hidden = NO;
    } else {
        [BQMsgView showInfo:@"当前镜头不支持闪光灯"];
    }
}

#pragma mark - GestureAction

- (void)tapGesturAction:(UITapGestureRecognizer *)sender {
    
    CGPoint focusPoint = [sender locationInView:sender.view];
    self.view.userInteractionEnabled = NO;
    [self focusLayerAnimation:focusPoint];
    
    if (self.camera.cameraPosition == AVCaptureDevicePositionBack) {
        focusPoint = CGPointMake( focusPoint.y /sender.view.bounds.size.height ,1-focusPoint.x/sender.view.bounds.size.width);
    } else {
        focusPoint = CGPointMake(focusPoint.y /sender.view.bounds.size.height ,focusPoint.x/sender.view.bounds.size.width);
    }
    
    if([self.camera.inputCamera isExposurePointOfInterestSupported] && [self.camera.inputCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
    {
        NSError *error;
        if ([self.camera.inputCamera lockForConfiguration:&error]) {
            [self.camera.inputCamera setExposurePointOfInterest:focusPoint];
            [self.camera.inputCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            if ([self.camera.inputCamera isFocusPointOfInterestSupported] && [self.camera.inputCamera isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                [self.camera.inputCamera setFocusPointOfInterest:focusPoint];
                [self.camera.inputCamera setFocusMode:AVCaptureFocusModeAutoFocus];
            }
            [self.camera.inputCamera unlockForConfiguration];
        } else {
            NSLog(@"ERROR = %@", error);
        }
    }
}

static CGFloat kZoomValue;

- (void)pinGestureAction:(UIPinchGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.currentZoom = self.camera.inputCamera.videoZoomFactor;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        kZoomValue = self.currentZoom * sender.scale;
        if (kZoomValue < 1 || kZoomValue > 4) {
            return;
        }
        [self.camera.inputCamera lockForConfiguration:nil];
        self.camera.inputCamera.videoZoomFactor = kZoomValue;
        [self.camera.inputCamera unlockForConfiguration];
        
    }
}

- (void)focusLayerAnimation:(CGPoint)point {
    CALayer *focusLayer = self.foucsLayer;
    focusLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [focusLayer setPosition:point];
    focusLayer.transform = CATransform3DMakeScale(2.0f,2.0f,1.0f);
    [CATransaction commit];
    
    CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform" ];
    animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeScale(1.0f,1.0f,1.0f)];
    animation.delegate = self;
    animation.duration = 0.3f;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [focusLayer addAnimation: animation forKey:@"animation"];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.foucsLayer.hidden = YES;
    self.view.userInteractionEnabled = YES;
}

#pragma mark - BtnAction

- (void)topRightBtnAction:(UIButton *)sender {
    NSLog(@"拍照、录视频转换按钮");
    sender.selected = !sender.selected;
    self.photoBottomView.hidden = sender.selected;
    self.videoBottomView.hidden = !sender.selected;
    if (sender.selected) {
        [self updateMovieWrite];
    } else {
        [self.movieWriter cancelRecording];
        self.videoBtn.selected = NO;
        [self closeTorchModel];
    }
}

- (void)closeTorchModel {
    if (self.camera.inputCamera.hasTorch) {
        [self.camera.inputCamera lockForConfiguration:nil];
        self.camera.inputCamera.torchMode = AVCaptureTorchModeOff;
        [self.camera.inputCamera unlockForConfiguration];
        [self loadImgInBtn:self.torchBtn];
    }
}

- (void)photoBtnAction:(UIButton *)sender {
    NSLog(@"拍照按钮点击");
    [self.camera capturePhotoAsImageProcessedUpToFilter:self.filter withOrientation:UIImageOrientationUp withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        if (processedImage) {
            GPUImageFliterPrccessVc * prccessVc = [[GPUImageFliterPrccessVc alloc] initWithImage:processedImage];
            [self.navigationController presentViewController:prccessVc animated:YES completion:nil];
        }
    }];
}

- (void)videoBtnAction:(UIButton *)sender {
    NSLog(@"录像按钮点击");
    if (!sender.selected) { //开始录制
        [self.movieWriter startRecording];
    } else { //结束录制
        WeakSelf;
        [self.movieWriter finishRecordingWithCompletionHandler:^{
            [weakSelf saveVideo];
        }];
    }
    
    sender.selected = !sender.selected;
}
//videoPath为视频下载到本地之后的本地路径
- (void)saveVideo{
    
    if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.movieUrlStr)) {
        //保存相册核心代码
        UISaveVideoAtPathToSavedPhotosAlbum(self.movieUrlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
}
//保存视频完成之后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    [self updateMovieWrite];
    if (error) {
        [BQMsgView showInfo:[NSString stringWithFormat:@"保存视频失败%@", error.localizedDescription]];
    } else {
        [BQMsgView showInfo:@"保存视频成功"];
    }
    
}

- (void)flashBtnAction:(UIButton *)sender {
    NSLog(@"闪光灯按钮点击");
    [self showCameralightModelView];
}

- (void)torchBtnAction:(UIButton *)sender {
    NSLog(@"手电筒按钮点击");
    [self showCameralightModelView];
}

- (void)loadImgInBtn:(UIButton *)sender {
    
    NSInteger status = sender == self.flashBtn ? self.camera.inputCamera.flashMode: self.camera.inputCamera.torchMode;
    NSString * imgName = @"";
    switch (status) {
        case 0:
            imgName = @"camera_flash_close";
            break;
        case 1:
            imgName = @"camera_flash_open";
            break;
        case 2:
            imgName = @"camera_flash_auto";
            break;
        default:
            break;
    }
    [sender setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}



- (void)modelBtnAction:(UIButton *)sender {
    self.lightModelView.hidden = YES;
    [self.camera.inputCamera lockForConfiguration:nil];
    if (sender.tag == CameraModelBtnType_Auto) {
        if (self.videoBottomView.hidden) {
            self.camera.inputCamera.flashMode = AVCaptureFlashModeAuto;
        } else {
            self.camera.inputCamera.torchMode = AVCaptureTorchModeAuto;
        }
    } else if (sender.tag == CameraModelBtnType_Open){
        if (self.videoBottomView.hidden) {
            self.camera.inputCamera.flashMode = AVCaptureFlashModeOn;
        } else {
            self.camera.inputCamera.torchMode = AVCaptureTorchModeOn;
        }
    } else {
        if (self.videoBottomView.hidden) {
            self.camera.inputCamera.flashMode = AVCaptureFlashModeOff;
        } else {
            self.camera.inputCamera.torchMode = AVCaptureTorchModeOff;
        }
    }
    [self.camera.inputCamera unlockForConfiguration];
    
    
    if (self.videoBottomView.hidden) {
        [self loadImgInBtn:self.flashBtn];
    } else {
        [self loadImgInBtn:self.torchBtn];
    }
    
}

- (void)rotateBtnAction:(UIButton *)sender {
    NSLog(@"镜头切换按钮点击");
    NSLog(@"%lf == %lf == %lf",self.camera.inputCamera.minAvailableVideoZoomFactor , self.camera.inputCamera.videoZoomFactor ,self.camera.inputCamera.maxAvailableVideoZoomFactor);
    [self.camera rotateCamera];
    
    if (!self.camera.inputCamera.hasTorch) {
        [self loadImgInBtn:self.torchBtn];
    }
    NSLog(@"%lf == %lf == %lf",self.camera.inputCamera.minAvailableVideoZoomFactor , self.camera.inputCamera.videoZoomFactor ,self.camera.inputCamera.maxAvailableVideoZoomFactor);
    
}

- (CALayer *)foucsLayer {
    if (_foucsLayer == nil) {
        CALayer * foucslayer = [CALayer layer];
        foucslayer.bounds = CGRectMake(0, 0, 60, 60);
        foucslayer.contents = (__bridge id)[UIImage imageNamed:@"camera_foucs"].CGImage;
        foucslayer.hidden = YES;
        [self.view.layer addSublayer:foucslayer];
        _foucsLayer = foucslayer;
    }
    return _foucsLayer;
}

- (UIView *)lightModelView {
    if (_lightModelView == nil) {
        CGFloat widthBtn = 60;
        CGFloat heightBnt = 40;
        NSArray * titleArr = @[@"自动", @"开启", @"关闭"];
        UIView * modelView = [[UIView alloc] initWithFrame:CGRectMake(0, self.videoBottomView.top - heightBnt, widthBtn * titleArr.count, heightBnt)];
        modelView.backgroundColor = self.videoBottomView.backgroundColor;
        for (NSInteger i = 0; i < titleArr.count; i++) {
            UIButton * modelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            modelBtn.frame = CGRectMake(i * widthBtn, 0, widthBtn, heightBnt);
            [modelBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            [modelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [modelBtn addTarget:self action:@selector(modelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            modelBtn.tag = i + CameraModelBtnType_Auto;
            [modelView addSubview:modelBtn];
        }
        modelView.hidden = YES;
        [self.view addSubview:modelView];
        _lightModelView = modelView;
    }
    return _lightModelView;
}

@end
