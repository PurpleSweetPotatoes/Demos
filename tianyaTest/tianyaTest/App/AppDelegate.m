//
//  AppDelegate.m
//  tianyaTest
//
//  Created by baiqiang on 2018/9/13.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UITabBarItem *item=[UITabBarItem appearance];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBHexString(@"1296db")} forState:UIControlStateSelected];
    
    NSArray * vcInfos = @[@{kVcName : @"MyDemosVc",
                            kVcTitle : @"demos",
                            kNormalImg : @"dirs",
                            kSelectImg : @"dirs_select"
                            },
                          @{kVcName : @"MySpiderVc",
                            kVcTitle : @"spider",
                            kNormalImg : @"spider",
                            kSelectImg : @"spider_select"
                            },
                          @{kVcName : @"MyInfoVc",
                            kVcTitle : @"info",
                            kNormalImg : @"about",
                            kSelectImg : @"about_select"
                            }
                          ];
    self.window.rootViewController = [UITabBarController createVcWithInfo:vcInfos];
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)win
{

        UIViewController *visibleVC = win.rootViewController;
        // AVPlayerVc
        if ([visibleVC.childViewControllers.lastObject isKindOfClass:NSClassFromString(@"AVPlayerVc")]) { // 直播、观看直播都有横屏需求
            return UIInterfaceOrientationMaskAll;
        }

        //除了看大图、横屏直播、观看横屏直播，其余的不可以横屏
        return UIInterfaceOrientationMaskPortrait;
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
