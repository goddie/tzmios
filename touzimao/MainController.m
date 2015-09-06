//
//  MainController.m
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "MainController.h"
#import "PopListController.h"
#import "FundListController.h"
#import "MyPageTableController.h"
#import "ContactListController.h"
#import "LoginUtil.h"
#import "LoginController.h"
#import "UserPageTableController.h"
#import "AppDelegate.h"

@interface MainController ()

@end

@implementation MainController
{
    UINavigationController *nav11;
    UINavigationController *nav21;
    UINavigationController *nav31;
    UINavigationController *nav41;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openAdvise:) name:@"openAdvise"object:nil];
    
    
    //b.创建子控制器
    PopListController *nav1= [[PopListController alloc] initWithNibName:@"PopListController" bundle:nil];
    nav11 = [[UINavigationController alloc] initWithRootViewController:nav1];
    nav11.tabBarItem.title=@"红人圈";
    nav11.tabBarItem.image=[UIImage imageNamed:@"btn1active.png"];
    //nav11.navigationController.navigationBar.translucent = NO;
    
    FundListController *nav2= [[FundListController alloc] initWithNibName:@"FundListController" bundle:nil];
    nav21 = [[UINavigationController alloc] initWithRootViewController:nav2];
    nav21.tabBarItem.title=@"聚宝盆";
    nav21.tabBarItem.image=[UIImage imageNamed:@"btn2active.png"];
    //nav21.navigationController.navigationBar.translucent = NO;
    
    ContactListController *nav3= [[ContactListController alloc] initWithNibName:@"ContactListController" bundle:nil];
    nav31 = [[UINavigationController alloc] initWithRootViewController:nav3];
    nav31.tabBarItem.title=@"通讯录";
    nav31.tabBarItem.image=[UIImage imageNamed:@"btn3active.png"];
    //nav31.navigationController.navigationBar.translucent = NO;
    
 
    NSString *username = [LoginUtil getLocalUser];
    //NSString *uuid = [LoginUtil getLocalUUID];
    

    UIViewController *nav4;
    MyPageTableController *c1 = [[MyPageTableController alloc] initWithNibName:@"MyPageTableController" bundle:nil];
    c1.uuid = [LoginUtil getLocalUUID];
    nav4 = c1;

//    if (!username) {
//        nav4= [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
//    }else
//    {
//        MyPageTableController *c1 = [[MyPageTableController alloc] initWithNibName:@"MyPageTableController" bundle:nil];
//        c1.uuid = [LoginUtil getLocalUUID];
//        nav4 = c1;
//    }
    
    
    //MyPageTableController *nav4= [[MyPageTableController alloc] initWithNibName:@"MyPageTableController" bundle:nil];
    nav41 = [[UINavigationController alloc] initWithRootViewController:nav4];
    nav41.tabBarItem.title=@"个人中心";
    nav41.tabBarItem.image=[UIImage imageNamed:@"btn4active.png"];
    //nav41.navigationController.navigationBar.translucent = NO;
    
    //c.2第二种方式
    self.viewControllers=@[nav11,nav21,nav31,nav41];
    
    self.tabBar.tintColor = [GlobalConst tabTintColor];
    self.tabBar.backgroundColor = [GlobalConst tabBgColor];
    self.tabBar.translucent = NO;
    
    NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:dict];
    //[[UINavigationBar appearance] setTranslucent:NO];
    
    
    self.navigationController.navigationBar.translucent = NO;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[GlobalConst bgRed]];
    
//    UITabBar* tabBar = self.tabBar;
//    
//    [tabBar setTranslucent:NO];
//    [tabBar setBarTintColor:[GlobalConst tabTintColor]];
//    [tabBar setBackgroundColor:[GlobalConst tabBgColor]];
    
    
    
//    NSArray *array = [self.view subviews];
//    UITabBar *tabBar = [array objectAtIndex:1];
//    tabBar.layer.contents = [GlobalConst tabBgColor];
    
    
    UINavigationBar* navigationBar =  [UINavigationBar appearance];
    [navigationBar setTranslucent:NO];

    //self.extendedLayoutIncludesOpaqueBars = YES;
    //[navigationBar setBarTintColor:[GlobalUtil colorWithArray: TabBarBgColor]];
    
    //NSDictionary *dict = @{NSForegroundColorAttributeName : [GlobalConst tabTintColor],NSBackgroundColorAttributeName : [GlobalConst tabBgColor]};
    //navigationBar.titleTextAttributes = dict;
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)openAdvise:(NSNotification*)notification
{
    NSString *uuid = (NSString*)notification.object;
    UserPageTableController *c1 = [[UserPageTableController alloc] initWithNibName:@"UserPageTableController" bundle:nil];
    c1.uuid =uuid;
    NSMutableArray *arr2 = [NSMutableArray arrayWithArray:nav11.viewControllers];
    [arr2 addObject:c1];
    nav11.viewControllers = arr2;
}

@end
