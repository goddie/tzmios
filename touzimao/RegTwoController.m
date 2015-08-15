//
//  RegTwoController.m
//  touzimao
//
//  Created by goddie on 15/8/13.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "RegTwoController.h"

#import "AFNetworking.h"
#import "MTLJSONAdapter.h"
#import "User.h"
#import "LoginUtil.h"

@interface RegTwoController ()

@end

@implementation RegTwoController
{
    NSInteger secondsCountDown;
    NSTimer *countDownTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"注册";
    
    secondsCountDown = 60;//60秒倒计时
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
    [self.btnSend setTitle:@"60" forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnSendClick:(id)sender {

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"phone":self.phone
                                 };
    [manager POST:[GlobalUtil requestURL:@"user/json/regsms"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            secondsCountDown = 60;
            [countDownTimer setFireDate:[NSDate distantPast]];
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
}

-(void)timerFireMethod{
    
    secondsCountDown--;
    self.btnSend.enabled = NO;
    
    [self.btnSend setTitle:[NSString stringWithFormat:@"%ld",secondsCountDown] forState:UIControlStateNormal];
    
    if(secondsCountDown==0){
        self.btnSend.enabled = YES;
        [self.btnSend setTitle:@"重发" forState:UIControlStateNormal];
//        [countDownTimer invalidate];
        [countDownTimer setFireDate:[NSDate distantFuture]];
    }
    
    
}


-(void)doLogin:(NSString*)username password:(NSString*)password
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"username":username,
                                 @"password":password
                                 };
    [manager POST:[GlobalUtil requestURL:@"user/json/login"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSDictionary *data = [dict objectForKey:@"data"];
            User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:nil];
            [LoginUtil saveLocalUser:model];
            [LoginUtil saveLocalUUID:model];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (IBAction)btnRegClick:(id)sender {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"phone":self.phone,
                                 @"password":self.txt2.text,
                                 @"code":self.txt1.text
                                 };
    [manager POST:[GlobalUtil requestURL:@"user/json/regpassword"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            [self doLogin:self.phone password:self.txt2.text];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}


@end
