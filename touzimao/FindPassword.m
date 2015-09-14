//
//  FindPassword.m
//  touzimao
//
//  Created by goddie on 15/9/12.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "FindPassword.h"
#import "UIViewController+Custome.h"

@interface FindPassword ()

@end

@implementation FindPassword
{
    User *user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"找回密码";
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

- (IBAction)btn2Click:(id)sender {
    if (!self.txt1.text) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入登录帐号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    self.btn2.enabled = NO;
    
    NSDictionary *parameters = @{
                                 @"username":self.txt1.text
                                 };
    [self showHud];
    
    [self post:@"user/json/findpasswordsms" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码已发送到注册手机号。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            
            NSDictionary *data = [dict objectForKey:@"data"];
            user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:nil];
            
        }
        
        [self hideHud];
        
    }];
    
}

- (IBAction)btn1Click:(id)sender {
    
    if (!user.uuid) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请获取验证码。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    if (![self.txt2.text isEqualToString:self.txt3.text]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码不一致。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    if (!self.txt4.text) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"password":self.txt2.text,
                                 @"uid":user.uuid,
                                 @"code":self.txt4.text
                                 };
    
    
    [self post:@"user/json/uppassword" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
}
@end
