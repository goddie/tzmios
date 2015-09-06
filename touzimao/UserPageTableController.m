//
//  UserPageTableController.m
//  touzimao
//  用户页面
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "UserPageTableController.h"
#import "MyPageTableCell.h"
#import "UserPageController.h"
#import "AccountController.h"
#import "AFNetworking.h"
#import "User.h"
#import "LoginUtil.h"
#import "WebPageController.h"
#import "TradeListController.h"
#import "UIImageView+WebCache.h"

@interface UserPageTableController ()

@end

@implementation UserPageTableController
{
    NSArray *buttons;
    UserPageController *headerView;
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    buttons =[ NSArray arrayWithObjects:@"投资组合",@"投资历史",@"个人介绍", nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    headerView = [[UserPageController alloc] initWithNibName:@"UserPageController" bundle:nil];
    headerView.uuid = self.uuid;
    //[headerView loadData];
    
    [self addChildViewController:headerView];
    
 

    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.tableFooterView = v;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.delaysContentTouches = NO;
    
    
    
    if (self.uuid.length>0) {
        [self loadData];
    }
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)img1Click:(id)sender
{
    AccountController *controller =  [[AccountController alloc] initWithNibName:@"AccountController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (UIView*)addButton
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120.0f)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 302, 46)];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"redBtn.png"] forState:UIControlStateNormal];
    [btn setTitle:@"立即购买" forState:UIControlStateNormal];
    
    [view addSubview:btn];
    
    
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    return  view;
}

-(void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"uid":self.uuid
                                 };
    [manager POST:[GlobalUtil requestURL:@"user/json/detail"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
            NSDictionary *dc = [dict objectForKey:@"data"];
            
            
            User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dc error:nil];
   
            if (model.avatar) {
                NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:model.avatar]];
                [headerView.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"avatar.png"]];
            }
            headerView.txtName.text = model.nickname;
            headerView.txtTotal.text = [NSString stringWithFormat:@"%@",[model.totalIncome stringValue]];
            headerView.txtYesterday.text = [NSString stringWithFormat:@"%@",[model.lastIncome stringValue]];
            headerView.txtLv.text = [NSString stringWithFormat:@"%@级投资猫达人",[model.level stringValue]];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  283.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    
    return headerView.view;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == 1) {
        
        TradeListController *c1 = [[TradeListController alloc] initWithNibName:@"TradeListController" bundle:nil];
        c1.uuid = self.uuid;
        
        [self.navigationController pushViewController:c1 animated:YES];
        
        return;
    }
    
    
    WebPageController *web = [[WebPageController alloc] initWithNibName:@"WebPageController" bundle:nil];
    web.title = [buttons objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:web animated:YES];
}
 
@end
