//
//  CashOutController.m
//  touzimao
//  交易提现
//  Created by goddie on 15/8/3.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "CashOutController.h"
#import "BuyProductInputCell.h"
#import "UIViewController+Custome.h"
#import "SingleInputCell.h"
#import "ConfigCell.h"

@interface CashOutController ()

@end

@implementation CashOutController
{
    NSArray *dataArr;
    User *user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"交易提现";
    
    self.tableView.tableFooterView =  [self addButton];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    dataArr = @[@"账户余额",@"提现金额"];
    
    [self loadData];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)loadData
{

    NSString *uid = [self checkLogin];
    
    NSDictionary *parameters = @{
                                 @"uid":uid
                                 };
    [self showHud];
    [self post:@"user/json/detail" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSDictionary *dc = [dict objectForKey:@"data"];
            user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dc error:nil];
            [self.tableView reloadData];
        }
        [self hideHud];
    }];
    
}



- (UIView*)addButton
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120.0f)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 302, 46)];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"redBtn.png"] forState:UIControlStateNormal];
    [btn setTitle:@"提现" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(cashClick) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn];
    
    
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    return  view;
}


-(void)cashClick
{
    NSString *uid = [self checkLogin];
    SingleInputCell *cell1 = (SingleInputCell*)[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *cashAmount = cell1.value1.text ;
    NSDictionary *parameters = @{
                                 @"uid":uid,
                                 @"total":cashAmount
                                 };
    
    [self post:@"cashout/json/add" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        if ([dict objectForKey:@"msg"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }

       
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row==1) {
        static NSString *CellIdentifier = @"SingleInputCell";
        SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.txt1.text = [dataArr objectAtIndex:indexPath.row];
        cell.value1.placeholder = @"输入提现金额";
//        [cell.value1 becomeFirstResponder];
        
        return cell;
    }
    
    
    static NSString *CellIdentifier = @"ConfigCell";
    ConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.accessoryType = UITableViewCellAccessoryNone ;
    
    if(cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.txtName.text = [dataArr objectAtIndex:indexPath.row];
    if (user) {
        cell.txtValue.text = [GlobalUtil toString:user.wealth];
    }
    
    return cell;
}

@end
