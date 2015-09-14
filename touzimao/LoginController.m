//
//  LoginController.m
//  touzimao
//
//  Created by goddie on 15/8/2.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "LoginController.h"
#import "RegOneController.h"
#import "AFNetworking.h"
#import "MTLJSONAdapter.h"
#import "User.h"
#import "LoginUtil.h"
#import "MyPageTableController.h"
#import "RegThreeController.h"
#import "UIViewController+Custome.h"
#import "FindPassword.h"

@interface LoginController ()

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
//    
//    tapGr.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:tapGr];
    
    self.title = @"登录";
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
 
- (IBAction)btn1Click:(id)sender {
 

    NSDictionary *parameters = @{
                                 @"username":self.txtUsername.text,
                                 @"password":self.txtPassword.text
                                 };
    [self showHud];
    
    [self post:@"user/json/login" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSDictionary *data = [dict objectForKey:@"data"];
            User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:nil];
            //NSLog(@"%@",model);
            [LoginUtil saveLocalUser:model];
            [LoginUtil saveLocalUUID:model];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:NO completion:^{
            }];

        }
        
        [self hideHud];
        
        if ([dict objectForKey:@"msg"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }

    }];
    
    
    
}


- (IBAction)btn2Click:(id)sender {
    RegOneController *c1 = [[RegOneController alloc] initWithNibName:@"RegOneController" bundle:nil];
    [self.navigationController pushViewController:c1 animated:YES];
    
}




//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txtUsername resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}


//-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
//    [self.txtUsername resignFirstResponder];
//}

- (IBAction)btn3Click:(id)sender {
    FindPassword *c1 = [[FindPassword alloc] initWithNibName:@"FindPassword" bundle:nil];
    [self.navigationController pushViewController:c1 animated:YES];
}
@end
