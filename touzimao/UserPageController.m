//
//  UserPageController.m
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "UserPageController.h"
#import "AccountController.h"
#import "AFNetworking.h"
#import "User.h"
#import "LoginUtil.h"
#import "ChatController.h"

@interface UserPageController ()

@end

@implementation UserPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [GlobalUtil addTouchToView:self sender:self.img1 action:@selector(img1Click:)];
    
    self.txtName.text = @"goddie";
    
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[[UIImage imageNamed:@"mask.png"] CGImage];
    mask.frame = CGRectMake(0, 0, 75, 75);
    
    self.img1.layer.mask = mask;
    self.img1.layer.masksToBounds = YES;
    self.img1.image = [UIImage imageNamed:@"header.png"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)img1Click:(id)sender
{
    

    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnInviteClick:(id)sender {
    NSString *userId = [LoginUtil getLocalUUID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"from":userId,
                                 @"sendTo":self.uuid,
                                 @"status":@"0"
                                 };
    
    [manager POST:[GlobalUtil requestURL:@"follow/json/add"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            UIAlertView *alert =[ [UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (IBAction)btnChatClick:(id)sender {
    
    
    ChatController *c1 = [[ChatController alloc] initWithNibName:@"ChatController" bundle:nil];
    c1.sendTo = [LoginUtil getLocalUUID];
    c1.from = self.uuid;
    
    [self.navigationController pushViewController:c1 animated:YES];
    
    
}
- (IBAction)btnFollowClick:(id)sender {
    
    NSString *userId = [LoginUtil getLocalUUID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"from":userId,
                                 @"sendTo":self.uuid,
                                 @"status":@"1"
                                 };
    
    [manager POST:[GlobalUtil requestURL:@"follow/json/add"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            UIAlertView *alert =[ [UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

@end
