//
//  MyPageTableController.m
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "MyPageTableController.h"
#import "MyPageTableCell.h"
#import "MyPageController.h"
#import "MyFundController.h"
#import "TradeListController.h"
#import "SysConfigController.h"
#import "AccountController.h"
#import "AFNetworking.h"
#import "LoginUtil.h"
#import "User.h"
#import "MyCatAccountController.h"
#import "CashOutController.h"


@interface MyPageTableController ()

@end

@implementation MyPageTableController
{
    NSArray *buttons;
    MyPageController *headerView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"MyPageTableController viewDidLoad");
    
    buttons = [NSArray arrayWithObjects:@"交易提现",@"已持基金",@"交易明细",@"猫币账户",nil];
    
    headerView = [[MyPageController alloc] initWithNibName:@"MyPageController" bundle:nil];
    [self addChildViewController:headerView];
    
    
//    CGRect newFrame = self.tableView.tableHeaderView.frame;
//    newFrame.size.height = 324.0f;
//    self.tableView.tableHeaderView.frame = newFrame;
    
    
//    [self.tableView sizeToFit];
//    CGRect newFrame = self.tableView.tableHeaderView.frame;
//    newFrame.size.height = 324.0f;
    
    
//    self.tableView.tableHeaderView.frame = newFrame;
//    [self.tableView setTableHeaderView:page.view];
    
    
//    self.tableView.tableHeaderView = nil;
//    [self.tableView.tableHeaderView removeFromSuperview];
//    
//    self.tableView.tableHeaderView = page.view;
    self.tableView.tableFooterView =  [self addButton];
    self.tableView.backgroundColor = [UIColor whiteColor];
   
    self.title = @"个人中心";
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 19, 19)];
    [btn setBackgroundImage:[UIImage imageNamed:@"iconSetting.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = right;
    
    
 
    
    if (self.uuid.length==0) {
        self.uuid= [LoginUtil getLocalUUID];
    }

    
    [self loadData];
    
//    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
//    self.tableView.tableFooterView = v;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)imgClick:(id)sender
{
    //NSLog(@"imgClick");
    
    AccountController *controller =  [[AccountController alloc] initWithNibName:@"AccountController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)rightClick
{
    SysConfigController *controller = [[SysConfigController alloc] initWithNibName:@"SysConfigController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}


- (UIView*)addButton
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120.0f)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 302, 46)];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"redBtn.png"] forState:UIControlStateNormal];
    [btn setTitle:@"申请\"投资猫达人\"" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(addApply) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn];
    
    
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    return  view;
}


-(void)addApply
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"uuid":self.uuid
                                 };
    NSLog(@"%@",self.uuid);
    
    [manager POST:[GlobalUtil requestURL:@"popularapply/json/add"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

-(void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"uid":self.uuid
                                 };
     NSLog(@"%@",self.uuid);
    
    [manager POST:[GlobalUtil requestURL:@"user/json/detail"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
            NSDictionary *dc = [dict objectForKey:@"data"];
            
           
            
            User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dc error:nil];
            
            
            headerView.txtName.text = model.nickname;
            headerView.txtTotal.text = [NSString stringWithFormat:@"%@",[model.totalIncome stringValue]];
            headerView.txtYesterday.text = [NSString stringWithFormat:@"%@",[model.lastIncome stringValue]];
            headerView.txtLevel.text = [NSString stringWithFormat:@"%@级投资猫达人",[model.level stringValue]];
            headerView.txtWealth.text = [NSString stringWithFormat:@"%@",[model.wealth stringValue]];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  324.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return headerView.view;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return buttons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyPageTableCell";
    MyPageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.txt1.text = [buttons objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CashOutController *nav = [[CashOutController alloc] initWithNibName:@"CashOutController" bundle:nil];
        [self.navigationController pushViewController:nav animated:YES];
    }
    
    if (indexPath.row == 1) {
        MyFundController *nav = [[MyFundController alloc] initWithNibName:@"MyFundController" bundle:nil];
        [self.navigationController pushViewController:nav animated:YES];
    }
    
    
    if (indexPath.row == 2) {
        TradeListController *nav = [[TradeListController alloc] initWithNibName:@"TradeListController" bundle:nil];
        [self.navigationController pushViewController:nav animated:YES];
    }
    
    if (indexPath.row == 3) {
        MyCatAccountController *nav = [[MyCatAccountController alloc] initWithNibName:@"MyCatAccountController" bundle:nil];
        [self.navigationController pushViewController:nav animated:YES];
    }
}


@end
