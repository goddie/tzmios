//
//  AppDelegate.h
//  touzimao
//
//  Created by goddie on 15/6/28.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) UINavigationController *activeController;


-(void)changeRoot;

-(void)changeReg;

@end

