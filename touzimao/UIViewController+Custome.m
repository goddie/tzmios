//
//  UIViewController+Custome.m
//  bullfight
//
//  Created by goddie on 15/8/18.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "UIViewController+Custome.h"


#import "AFNetworking.h"
#import "MTLJSONAdapter.h"
#import "User.h"
#import "LoginUtil.h"
#import "HttpUtil.h"


@implementation UIViewController (Custome)

MBProgressHUD *hud;

- (void)globalConfig
{
    
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.delegate = self;
    hud.labelText = @"Loading";
    
//    [hud showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}

//- (void)httpRequest
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//
//    [manager POST:[GlobalUtil requestURL:@"user/json/regsms"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dict = (NSDictionary *)responseObject;
//        if ([[dict objectForKey:@"code"] intValue]==1) {
//            
//            
//            
//        }else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//
//}

- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success
{
    [hud show:YES];
    
    [self post:url params:params success:^(id responseObj) {
        
        success(responseObj);
        
        [hud hide:YES];
        
    } failure:^(NSError *error) {
        
        [hud hide:YES];
        
        NSLog(@"%@",[params description]);
        NSLog(@"%@",[error description]);
    }];
    
//    [self post:url params:params success:success failure:^(NSError *error) {
//        NSLog(@"%@",[params description]);
//        NSLog(@"%@",[error description]);
//        
//    }];
}

- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    NSString *postURL = [GlobalUtil requestURL:url];
    [HttpTool post:postURL params:params success:success failure:failure];
}

@end
