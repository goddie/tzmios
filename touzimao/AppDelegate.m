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
#import <AlipaySDK/AlipaySDK.h>
#import "HttpUtil.h"
#import "AFNetworking.h"

static AppDelegate *appDelegate = nil;

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    MainController *mainController;
    
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    appDelegate = self;
    
    
    
    
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
    
    
    //向微信注册
    [WXApi registerApp:@"wxdd39261e73f1f6a1"];
    
    
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      //NSLog(@"result = %@",resultDic);
                                                      
//                                                      if ([[resultDic objectForKey:@"resultStatus"] intValue]==9000) {
//                                                          [self paySuccess:[resultDic objectForKey:@"result"]];
//                                                      }
                                                      
                                                      
                                                  }]; }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了, 所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就 是在这个方法里面处理跟 callback 一样的逻辑】
            //NSLog(@"result = %@",resultDic);
//            
//            if ([[resultDic objectForKey:@"resultStatus"] intValue]==9000) {
//                [self paySuccess:[resultDic objectForKey:@"result"]];
//            }

        }];
    }
    
    return [WXApi handleOpenURL:url delegate:self];
}






-(void) onReq:(BaseReq*)req
{

}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        
//        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", temp.code, temp.state, temp.errCode];
        
        if (temp.errCode==0 && temp.code) {
            
            [self getWXToken:temp.code];

        }

    }
}


-(void)getWXToken:(NSString*)code;
{
    NSDictionary *params = @{
                             @"appid":@"wxdd39261e73f1f6a1",
                             @"secret":@"2a48e11943790289522c1369b0ffb182",
                             @"code":code,
                             @"grant_type":@"authorization_code"
                             
                             };
    
    NSString *url = [@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxdd39261e73f1f6a1&secret=2a48e11943790289522c1369b0ffb182&grant_type=authorization_code&code=" stringByAppendingString:code];
    
    
    NSURL * URL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:URL];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"error: %@",[error localizedDescription]);
    }else{
        //NSLog(@"response : %@",response);
        NSLog(@"backData : %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        if ([dict objectForKey:@"access_token"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wxauth" object:dict];
        }
        
//        self.wxToken = [dict objectForKey:@"access_token"];
        
    }
}




/**
 *  支付成功
 */
-(void)paySuccess:(NSString*)result
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:result];
}

+ (AppDelegate *)delegate{
    
    return appDelegate;
    
}


-(void)changeRoot
{

    [self.window addSubview:mainController.view];
    
    [self.window.rootViewController.view removeFromSuperview];
    
    self.window.rootViewController = mainController;
    
    [appDelegate.window.rootViewController dismissViewControllerAnimated:NO completion:^{
        
    }];
}




 

-(void)loginPage
{
    NSString *uuid = [LoginUtil getLocalUUID];
    
    [self changeTab:0];
    
    if (!uuid) {
        
        RegOneController *c1 = [[RegOneController alloc] initWithNibName:@"RegOneController" bundle:nil];
        
        UINavigationController *nav  = [[UINavigationController alloc] initWithRootViewController:c1];
        
        [appDelegate.window.rootViewController presentViewController:nav animated:YES completion:^{
            
        }];
        
    }
    
}

-(void)changeTab:(NSInteger)idx
{
    mainController.selectedIndex = idx;
}


#pragma mark - UITabBarController
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //_activeController = (UINavigationController*)viewController;
}




@end
