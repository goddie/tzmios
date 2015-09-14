//
//  RegController.m
//  touzimao
//
//  Created by goddie on 15/8/2.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "UpPassword.h"
#import "AFNetworking.h"
#import "MTLJSONAdapter.h"
#import "Member.h"
#import "LoginUtil.h"
#import "LoginController.h"
#import "UIViewController+Custome.h"


@interface UpPassword ()

@end

@implementation UpPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
   
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

- (IBAction)btn1Click:(id)sender {
    
    
    if([self.txt1.text length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入新密码。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    if([self.txt2.text length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请再次确认密码。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    if (![self.txt1.text isEqualToString:self.txt2.text]) {
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"错误" message:@"两次密码不一致。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
    }
    
    if (!self.txt3.text) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    
    NSString *uid = [LoginUtil getLocalUUID];
    
    if(uid.length==0)
    {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"password":self.txt1.text,
                                 @"uid":uid,
                                 @"code":self.txt3.text
                                 };
    
    
    [self post:@"user/json/uppassword" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
    }];
    
    
}




//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)btn2Click:(id)sender {
    
    NSString *uid = [self checkLogin];
    
    self.btn2.enabled = NO;
    
    NSDictionary *parameters = @{
                                 @"uid":uid
                                 };
    [self showHud];
    
    [self post:@"user/json/uppasswordsms" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码已发送到注册手机号。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];

        }
        
        [self hideHud];
        
    }];

}

@end
