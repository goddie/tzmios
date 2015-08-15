//
//  RegOneController.m
//  touzimao
//
//  Created by goddie on 15/8/13.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "RegOneController.h"
#import "LoginController.h"
#import "RegTwoController.h"

#import "AFNetworking.h"
#import "MTLJSONAdapter.h"
#import "User.h"
#import "LoginUtil.h"

@interface RegOneController ()

@end

@implementation RegOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"手机验证";
    
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
//    RegTwoController *c1  = [[RegTwoController alloc] initWithNibName:@"RegTwoController" bundle:nil];
//    c1.phone  = self.txt1.text;
//    
//    [self.navigationController pushViewController:c1 animated:YES];
//    
//    return ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"phone":self.txt1.text
                                 };
    [manager POST:[GlobalUtil requestURL:@"user/json/regsms"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            RegTwoController *c1  = [[RegTwoController alloc] initWithNibName:@"RegTwoController" bundle:nil];
            c1.phone  = self.txt1.text;
            
            [self.navigationController pushViewController:c1 animated:YES];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
    

}



- (IBAction)btn2Click:(id)sender {
    
    LoginController *c1 = [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
    [self.navigationController pushViewController:c1 animated:YES];
    
}
@end
