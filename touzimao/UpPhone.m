//
//  UpPhone.m
//  touzimao
//
//  Created by goddie on 15/9/12.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "UpPhone.h"
#import "UIViewController+Custome.h"

@interface UpPhone ()

@end

@implementation UpPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手机号";
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


- (IBAction)btn1Click:(id)sender {
    if([self.txt1.text length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入新手机号。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    if([self.txt2.text length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }

    NSString *uid = [self checkLogin];
    
    NSDictionary *parameters = @{
                                 @"phone":self.txt1.text,
                                 @"uid":uid,
                                 @"code":self.txt2.text
                                 };
    
    
    [self post:@"user/json/upphone" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
    }];
    
}
@end
