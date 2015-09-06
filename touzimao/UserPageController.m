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
#import "JSQChat.h"
#import "User.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface UserPageController ()

@end

@implementation UserPageController
{
    User *model;
    User *login;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [GlobalUtil addTouchToView:self sender:self.img1 action:@selector(img1Click:)];
    
    self.txtName.text = @"";
    
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[[UIImage imageNamed:@"mask.png"] CGImage];
    mask.frame = CGRectMake(0, 0, 75, 75);
    
    self.img1.layer.mask = mask;
    self.img1.layer.masksToBounds = YES;
    self.img1.image = [UIImage imageNamed:@"avatar.png"];
    
    
    if ([LoginUtil hasFollow:self.uuid]) {
         self.txtFollow.text = @"已关注";
    }
    
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadData
{
    
    if (!self.uuid) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid":self.uuid
                                 };
    
    [self post:@"user/json/detail" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSDictionary *dc = [dict objectForKey:@"data"];
            model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dc error:nil];
            if (model) {
                [self bindData];
            }

        }
    }];
    
    
    NSString *loginId = [LoginUtil getLocalUUID];
    
    [self post:@"user/json/detail" params:@{@"uid":loginId} success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSDictionary *dc = [dict objectForKey:@"data"];
            login = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dc error:nil];
        }
    }];
    
}

-(void)bindData
{
    self.txtName.text = model.nickname;
    self.txtTotal.text = [NSString stringWithFormat:@"%@",[model.totalIncome stringValue]];
    self.txtYesterday.text = [NSString stringWithFormat:@"%@",[model.lastIncome stringValue]];
    self.txtLv.text = [NSString stringWithFormat:@"%@级投资猫达人",[model.level stringValue]];
    //self.txtt.text = [NSString stringWithFormat:@"%@",[model.wealth stringValue]];
    
    if (model.avatar) {
        NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:model.avatar]];
        [self.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"avatar.png"]];
    }
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
    if (login==nil) {
        [[AppDelegate delegate] loginPage];
    }

    JSQChat *c1 = [[JSQChat alloc] initWithNibName:@"JSQChat" bundle:nil];
    
    c1.from = login;
    
    c1.sendTo = model;
    
    c1.hidesBottomBarWhenPushed = YES;
    
//    ChatController *c1 = [[ChatController alloc] initWithNibName:@"ChatController" bundle:nil];
//    c1.sendTo = self.uuid;
//    c1.from =[LoginUtil getLocalUUID];
    
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
            
            self.txtFollow.text = @"已关注";
            
            [LoginUtil addFollowData:self.uuid];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

@end
