//
//  LoginController.m
//  touzimao
//
//  Created by goddie on 15/8/2.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "LoginController.h"
#import "RegController.h"
#import "AFNetworking.h"
#import "MTLJSONAdapter.h"
#import "User.h"
#import "LoginUtil.h"
#import "MyPageTableController.h"

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

- (IBAction)btn1Click:(id)sender {
 
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"username":self.txtUsername.text,
                                 @"password":self.txtPassword.text
                                 };
    [manager POST:[GlobalUtil requestURL:@"user/json/login"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
            NSDictionary *data = [dict objectForKey:@"data"];
            
            User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:nil];
            
            //NSLog(@"%@",model);
            
            
            [LoginUtil saveLocalUser:model];
            
            [LoginUtil saveLocalUUID:model];
            
            
            
            MyPageTableController *c1 = [[MyPageTableController alloc] initWithNibName:@"MyPageTableController" bundle:nil];
            
            c1.uuid = model.uuid;
            
//            [self.navigationController pushViewController:c1 animated:YES];
            
            self.navigationController.viewControllers = @[c1];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}


- (IBAction)btn2Click:(id)sender {
    RegController *c1 = [[RegController alloc] initWithNibName:@"RegController" bundle:nil];
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

@end