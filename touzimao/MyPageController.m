//
//  MyPageController.m
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "MyPageController.h"
#import "SysConfigController.h"
#import "AccountController.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Custome.h"
#import "AppDelegate.h"
#import "SingleInputCell.h"

@interface MyPageController ()

@end

@implementation MyPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.txtName.text = @"";
    self.uuid = [self checkLogin];

    [GlobalUtil addTouchToView:self sender:[self.view viewWithTag:10] action:@selector(imgClick:)];
    
    
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[[UIImage imageNamed:@"mask.png"] CGImage];
    mask.frame = CGRectMake(0, 0, 75, 75);
    
    self.img.layer.mask = mask;
    self.img.layer.masksToBounds = YES;
    self.img.image = [UIImage imageNamed:@"avatar.png"];
    
    
    
//    if (self.user.avatar) {
//        NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:self.user.avatar]];
//        [self.img sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"avatar.png"]];
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{

 
    [self loadData];
 
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)imgClick:(id)sender
{
//    NSLog(@"imgClick");
    
    AccountController *controller =  [[AccountController alloc] initWithNibName:@"AccountController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnConfigClick:(id)sender {
    SysConfigController *controller = [[SysConfigController alloc] initWithNibName:@"SysConfigController" bundle:nil];
    controller.user = self.user;
    
    [self.navigationController pushViewController:controller animated:YES];
}




-(void)loadData
{
    self.uuid = [self checkLogin];
    
    if (!self.uuid) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid":self.uuid
                                 };
    //     NSLog(@"%@",self.uuid);
    
    [self post:@"user/json/detail" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSDictionary *dc = [dict objectForKey:@"data"];
            User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dc error:nil];
            if (model) {
                self.user = model ;
                self.txtName.text = model.nickname;
                self.txtTotal.text = [NSString stringWithFormat:@"%@",[model.totalIncome stringValue]];
                self.txtYesterday.text = [NSString stringWithFormat:@"%@",[model.lastIncome stringValue]];
                self.txtLevel.text = [NSString stringWithFormat:@"%@级投资猫达人",[model.level stringValue]];
                self.txtWealth.text = [NSString stringWithFormat:@"%@",[model.wealth stringValue]];
                if (self.user.avatar) {
                    NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:self.user.avatar]];
                    [self.img sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"avatar.png"]];
                }
            }
        }
    }];
    
}
 
@end
