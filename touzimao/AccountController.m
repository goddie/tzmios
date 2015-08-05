//
//  AccountController.m
//  touzimao
//  账户管理
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "AccountController.h"
#import "UserHeaderCell.h"
#import "ConfigCell.h"
#import "BtnCell.h"
#import "LoginUtil.h"
#import "LoginController.h"

@interface AccountController ()

@end

@implementation AccountController
{
    NSArray *buttons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title =@"账户管理";
    
    buttons = [NSArray arrayWithObjects:@"头像管理",@"实名认证",@"身份认证",@"修改密码", nil];
    
    //[self setExtraCellLineHidden:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        return buttons.count;
    }
    
    if (section==1) {
        return  1.0f;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    static NSString *CellIdentifier = @"FundListCell";
    //    FundListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if(cell==nil){
    //
    //        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
    //        cell = [nib objectAtIndex:0];
    //    }
    //    return cell;
    if (indexPath.section==0) {
        
        if (indexPath.row ==0 ) {
            static NSString *CellIdentifier = @"UserHeaderCell";
            UserHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell==nil){
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            
            return cell;
        }
        
        
        static NSString *CellIdentifier = @"ConfigCell";
        ConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.txtName.text = [buttons objectAtIndex:indexPath.row];
        
        
        return cell;
        
    }
    
    if (indexPath.section==1) {
        
        static NSString *CellIdentifier = @"BtnCell";
        BtnCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.txt.text = @"退出登录";
        
        return cell;
        
    }
    

    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BtnCell *cell = (BtnCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.txt.text isEqualToString:@"退出登录"]) {
        
        [LoginUtil clearLocal];
        
        LoginController *c1 = [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
        
        
        self.navigationController.viewControllers  = @[c1];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}


@end
