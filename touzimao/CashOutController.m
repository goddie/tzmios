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

@interface CashOutController ()

@end

@implementation CashOutController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"交易提现";
    
    self.tableView.tableFooterView =  [self addButton];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSString *uid = [LoginUtil getLocalUUID];
    
    BuyProductInputCell *cell1 = (BuyProductInputCell*)[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    NSString *cashAmount = cell1.txt1.text ;
    
    
    
    NSDictionary *parameters = @{
                                 @"uid":uid,
                                 @"total":cashAmount
                                 };
    
    
    [self post:@"cashout/json/add" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            


        }
        
        
        if ([dict objectForKey:@"msg"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BuyProductInputCell";
    BuyProductInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.txt1.placeholder = @"输入提现金额";
    
    return cell;
}

@end
