//
//  AppDelegate.h
//  touzimao
//
//  Created by goddie on 15/6/28.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainController.h"
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) UINavigationController *activeController;


-(void)changeRoot;

-(void)loginPage;

+ (AppDelegate *)delegate;

-(void)changeTab:(NSInteger)idx;

/**
 *  微信token
 */
//@property (nonatomic, strong) NSString *wxToken;

@end

