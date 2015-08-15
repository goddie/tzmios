//
//  FundDetailController.m
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "FundDetailController.h"
#import "MyPageTableCell.h"
#import "FundDetailHeaderController.h"
#import "AccountController.h"
#import "AFNetworking.h"
#import "Product.h"
#import "BuyProductCell.h"
#import "BuyProductInputCell.h"
#import "LoginUtil.h"
#import "TradeRecord.h"
#import "WebPageController.h"

@interface FundDetailController ()

@end

@implementation FundDetailController
{
    NSArray *buttons;
    FundDetailHeaderController *headerView;
    NSArray *cellTitles;
    
    TradeRecord *tradeRecord;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    buttons = [NSArray arrayWithObjects:@"购买须知",@"产品详情", nil];
    
    headerView = [[FundDetailHeaderController alloc] initWithNibName:@"FundDetailHeaderController" bundle:nil];
    [self addChildViewController:headerView];
    
    self.tableView.tableHeaderView = headerView.view;
    
    //self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, 546.0f);
    
    //NSLog(@"%f",self.tableView.tableHeaderView.frame.size.height);
    
    self.tableView.tableFooterView = [self addButton];
    
    cellTitles = @[@"同意购买",@"公开收益",@"同步买入",@"同步卖出"];
    
    tradeRecord = [TradeRecord new];
    
    
    if (self.uuid.length>0) {
        [self loadData];
    }
    
    if (self.fid == nil) {
        self.fid=@"";
    }
    
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
    [btn setTitle:@"立即购买" forState:UIControlStateNormal];
    
    [view addSubview:btn];
    
    [btn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    return  view;
}

-(void)buyClick
{
    
    BuyProductInputCell *cell = (BuyProductInputCell*)[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
    tradeRecord.amount = [NSNumber numberWithFloat:[cell.txt1.text floatValue] * (-1)];
    
    BuyProductCell *cell1 = (BuyProductCell*)[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (cell1.sw1.on) {
        tradeRecord.agreeBuy = [NSNumber numberWithInt:1];
    }else
    {
        tradeRecord.agreeBuy = [NSNumber numberWithInt:0];
    }
    
    BuyProductCell *cell2 = (BuyProductCell*)[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    if (cell2.sw1.on) {
        tradeRecord.isShow = [NSNumber numberWithInt:1];
    }else
    {
        tradeRecord.isShow = [NSNumber numberWithInt:0];
    }
    
    
    BuyProductCell *cell3 = (BuyProductCell*)[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    if (cell3.sw1.on) {
        tradeRecord.synBuy= [NSNumber numberWithInt:1];
    }else
    {
        tradeRecord.synBuy = [NSNumber numberWithInt:0];
    }
    
    
    BuyProductCell *cell4 = (BuyProductCell*)[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    if (cell4.sw1.on) {
        tradeRecord.synSell = [NSNumber numberWithInt:1];
    }else
    {
        tradeRecord.synSell = [NSNumber numberWithInt:0];
    }
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"pid":self.uuid,
                                 @"uid":[LoginUtil getLocalUUID],
                                 @"fid":self.fid,
                                 @"amount":[tradeRecord.amount stringValue],
                                 @"optName":@"买进",
                                 @"agreeBuy":[tradeRecord.agreeBuy stringValue],
                                 @"isShow":[tradeRecord.isShow stringValue],
                                 @"synBuy":[tradeRecord.synBuy stringValue],
                                 @"synSell":[tradeRecord.synSell stringValue],
                                 @"type":@"1"
                                 
                                 };
    [manager POST:[GlobalUtil requestURL:@"traderecord/json/add"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            //NSDictionary *dc = [dict objectForKey:@"data"];
            
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
                                 @"uuid":self.uuid
                                 };
    [manager POST:[GlobalUtil requestURL:@"product/json/detail"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
            NSDictionary *dc = [dict objectForKey:@"data"];
            
            
            Product *model = [MTLJSONAdapter modelOfClass:[Product class] fromJSONDictionary:dc error:nil];
            
            headerView.txtPercent.text  = [NSString stringWithFormat:@"%@",[model.weekRate stringValue]] ;
            headerView.txtTenthou.text = [NSString stringWithFormat:@"%@",[model.tenThousand stringValue]];
            headerView.txtPubdate.text =[NSString stringWithFormat:@"%@",[GlobalUtil getDateFromUNIX:model.pubDate]];
            headerView.txtRisk.text = model.risk;
            headerView.txtCycle.text= [NSString stringWithFormat:@"%@",[model.cycle stringValue]];
            headerView.txtCash.text = model.cashTime;
            
 
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    
    if (section==1) {
        return cellTitles.count + 1;
    }
    
    return buttons.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        //购买须知
        if (indexPath.row==0) {
            WebPageController *web = [[WebPageController alloc] initWithNibName:@"WebPageController" bundle:nil];
            web.title = @"购买须知";
            web.URL = [baseURL stringByAppendingFormat:@"product/page/notice?pid=%@&type=1",self.uuid];
            [self.navigationController pushViewController:web animated:YES];
        }
        
        //产品详情
        if (indexPath.row==1) {
            WebPageController *web = [[WebPageController alloc] initWithNibName:@"WebPageController" bundle:nil];
            web.title = @"产品详情";
            web.URL = [baseURL stringByAppendingFormat:@"product/page/notice?pid=%@&type=2",self.uuid];
            
            [self.navigationController pushViewController:web animated:YES];
        }
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==1) {
        
        if (indexPath.row==4) {
            static NSString *CellIdentifier = @"BuyProductInputCell";
            BuyProductInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell==nil){
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            return cell;

        }
        
        static NSString *CellIdentifier = @"BuyProductCell";
        BuyProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.txt1.text = [cellTitles objectAtIndex:indexPath.row];
        
        return cell;
    }
    
    
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



@end
