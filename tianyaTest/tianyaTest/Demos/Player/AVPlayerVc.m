//
//  AVPlayerVc.m
//  tianyaTest
//
//  Created by baiqiang on 2019/1/28.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "AVPlayerVc.h"

#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayerControlView.h>
#import <ZFAVPlayerManager.h>

@interface AVPlayerVc ()
@property (nonatomic, strong) ZFPlayerController * player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@end

@implementation AVPlayerVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    self.containerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.sizeW, self.view.sizeW / 16 * 9)];
    
    self.controlView = [[ZFPlayerControlView alloc] init];
    self.controlView.fastViewAnimated = YES;
    
    [self.view addSubview:self.containerView];
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        [self.controlView showTitle:self.movieTitle coverImage:nil fullScreenMode: isFullScreen ?ZFFullScreenModeLandscape : ZFFullScreenModePortrait];
    };
    
    /// 播放完成
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager stop];
    };
    
    self.player.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        NSLog(@"======开始播放了");
    };
    
    self.player.assetURL = [NSURL URLWithString:self.movieUrl];
    [self.controlView showTitle:self.movieTitle coverImage:nil fullScreenMode:ZFFullScreenModePortrait];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSString *)movieUrl {
    return [_movieUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
@end
