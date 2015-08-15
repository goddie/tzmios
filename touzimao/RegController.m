//
//  RegController.m
//  touzimao
//
//  Created by goddie on 15/8/2.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "RegController.h"
#import "AFNetworking.h"
#import "MTLJSONAdapter.h"
#import "Member.h"
#import "LoginUtil.h"
#import "LoginController.h"


@interface RegController ()

@end

@implementation RegController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册用户";
   
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

- (IBAction)btn1Click:(id)sender {
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"username":self.txtUsername.text,
                                 @"password":self.txtPassword.text
                                 };
    [manager POST:[GlobalUtil requestURL:@"user/json/reg"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
            NSDictionary *data = [dict objectForKey:@"data"];
            
            User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:nil];

            //NSLog(@"%@",model);
            
            [LoginUtil saveLocalUser:model];
            
            [LoginUtil saveLocalUUID:model];
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            
            [self.navigationController popToRootViewControllerAnimated:YES];

        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
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

- (IBAction)btn2Click:(id)sender {
    LoginController *c1 = [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
    [self.navigationController pushViewController:c1 animated:YES];

}

- (IBAction)txt1End:(id)sender {
    
    [self.txtPassword becomeFirstResponder];
    
}

- (IBAction)txt2End:(id)sender {
    
    [sender resignFirstResponder];
}


@end
