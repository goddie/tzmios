//
//  AppDelegate.m
//  touzimao
//
//  Created by goddie on 15/6/28.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"
#import "EnterController.h"
#import "LoginUtil.h"
#import "RegOneController.h"
#import "IQKeyboardManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    MainController *mainController;
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //1.创建Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    self.window.backgroundColor = [GlobalUtil colorWithArray: AppBgColor];
    
    mainController =[[MainController alloc] initWithNibName:@"MainController" bundle:nil];
    mainController.delegate=self;
    
    
    //a.初始化一个tabBar控制器
    EnterController *ec = [[EnterController alloc] initWithNibName:@"EnterController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ec];
    
    self.window.rootViewController = nav;
    //设置控制器为Window的根控制器
    //self.window.rootViewController=tb;
    
    //2.设置Window为主窗口并显示出来
    [self.window makeKeyAndVisible];
    
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



-(void)changeRoot
{

    [self.window addSubview:mainController.view];
    
    [self.window.rootViewController.view removeFromSuperview];
    
    self.window.rootViewController = mainController;
}

-(void)changeReg
{
    
    RegOneController *c1 = [[RegOneController alloc] initWithNibName:@"RegOneController" bundle:nil];
    UINavigationController *nav  = [[UINavigationController alloc] initWithRootViewController:c1];
    [self.window addSubview:mainController.view];
    
    [self.window.rootViewController.view removeFromSuperview];
    
    self.window.rootViewController = nav;
}


#pragma mark - UITabBarController
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    _activeController = (UINavigationController*)viewController;
}

@end
