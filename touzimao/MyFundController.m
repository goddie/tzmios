//
//  MyFundController.m
//  touzimao
//  已持基金
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "MyFundController.h"
#import "MyFundCell.h"
#import "FundDetailController.h"
#import "AFNetworking.h"
#import "MTLJSONAdapter.h"
#import "Product.h"
#import "TradeRecord.h"
#import "LoginUtil.h"
#import "MyButton.h"
#import "UserPageTableController.h"
#import "MyFansController.h"

@interface MyFundController ()

@end

@implementation MyFundController
{
    NSMutableArray *dataArr;
    NSMutableArray *dataArr2;
    NSNumber *curPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"已持基金";
    
    dataArr = [NSMutableArray arrayWithCapacity:10];
    dataArr2 = [NSMutableArray arrayWithCapacity:10];
    curPage = [NSNumber numberWithInt:1];
    
    if (self.uuid.length==0) {
        self.uuid = [LoginUtil getLocalUUID];
    }
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"p":curPage,
                                 @"uid":self.uuid
                                 };
    [manager POST:[GlobalUtil requestURL:@"traderecord/json/mylist"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
            NSArray *arr = [dict objectForKey:@"data"];
            
            for (NSDictionary *dc in arr) {
                //NSLog(@"%@",dc);
                
                TradeRecord *model = [MTLJSONAdapter modelOfClass:[TradeRecord class] fromJSONDictionary:dc error:nil];
                
                if (model!=NULL) {
                    
                    NSDictionary *dc3 = [dc objectForKey:@"follow"];
                    
                    if (![dc3 isEqual:[NSNull null]]) {
                        User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dc3 error:nil];
                        model.follow = user.uuid;
                    }
                    
                    
                    
                    [dataArr addObject:model];
                }
                
                NSDictionary *dc2 =[dc objectForKey:@"product"];
                
                Product *model2 = [MTLJSONAdapter modelOfClass:[Product class] fromJSONDictionary:dc2 error:nil];
                if (model2!=NULL) {
                
                    
                    [dataArr2 addObject:model2];
                }
            }
            
            [self.tableView reloadData];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


-(void)myFollow:(MyButton*)sender
{
    NSString *fid =[ NSString stringWithFormat:@"%@",sender.data];
    
    UserPageTableController *controller = [[UserPageTableController alloc] initWithNibName:@"UserPageTableController" bundle:nil];
    controller.uuid = fid;
    
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

-(void)followMe:(MyButton*)sender
{
    NSString *pid =[ NSString stringWithFormat:@"%@",sender.data];
    
    
    MyFansController *c1 = [[MyFansController alloc] initWithNibName:@"MyFansController" bundle:nil];
    c1.pid = pid;
    [self.navigationController pushViewController:c1 animated:YES];
    

}

-(void)isOpen:(MyButton*)sender
{
    
    NSArray *arr = (NSArray*)sender.data;
    
    NSString *tid = [arr objectAtIndex:0];
    NSString *isopen =[arr objectAtIndex:1];
    
    if ([isopen isEqual:@"1"]) {
        isopen = @"0";
        
        [sender setBackgroundImage:[UIImage imageNamed:@"iconUnChecked.png"] forState:UIControlStateNormal];
    }else
    {
        isopen = @"1";
        [sender setBackgroundImage:[UIImage imageNamed:@"iconChecked.png"] forState:UIControlStateNormal];
    }
    
    sender.data = @[tid,isopen];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"tid":tid,
                                 @"isopen":isopen
                                 };
    [manager POST:[GlobalUtil requestURL:@"traderecord/json/isopen"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
            NSDictionary *dc = [dict objectForKey:@"data"];
            
 
            TradeRecord *model = [MTLJSONAdapter modelOfClass:[TradeRecord class] fromJSONDictionary:dc error:nil];
            
            if (model==NULL) {
                NSLog(model.isShow);
            }
            

            
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
    return dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyFundCell";
    MyFundCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    TradeRecord *tr =(TradeRecord*)[dataArr objectAtIndex:indexPath.row];
    Product *p = (Product*)[dataArr2 objectAtIndex:indexPath.row];
    
    cell.txtName.text = p.name;
    cell.txtIncome.text = [NSString stringWithFormat:@"%@",[p.weekRate stringValue]];
    cell.txtHold.text =  [NSString stringWithFormat:@"%@",[tr.amount stringValue]];
    
    
    if (tr.follow.length>0) {
        
        NSString *fid = tr.follow;
        [GlobalUtil addButton:self sender:cell.txtMyFollow action:@selector(myFollow:) data:fid];
    }else
    {
        cell.txtMyFollow.hidden=YES;
    }
    
    if ([tr.hasFans intValue]>0) {
        
        [GlobalUtil addButton:self sender:cell.txtFollowMe action:@selector(followMe:) data:p.uuid];
    }else
    {
        cell.txtFollowMe.hidden=YES;
    }
    
    if ([tr.isShow intValue]==1) {
        [cell.btnIsOpen setBackgroundImage:[UIImage imageNamed:@"iconChecked.png"] forState:UIControlStateNormal];
    }else
    {
        [cell.btnIsOpen setBackgroundImage:[UIImage imageNamed:@"iconUnChecked.png"] forState:UIControlStateNormal];
    }
    
    cell.btnIsOpen.data = @[tr.uuid,[tr.isShow stringValue]];
    [cell.btnIsOpen addTarget:self action:@selector(isOpen:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyFundCell *cell = (MyFundCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    FundDetailController *controller = [[FundDetailController alloc] initWithNibName:@"FundDetailController" bundle:nil];
    
    
    
    Product *p = (Product*)[dataArr2 objectAtIndex:indexPath.row];
    
    controller.title = cell.txtName.text;
    
    controller.uuid = p.uuid;
    
    [self.navigationController pushViewController:controller animated:YES];
}


@end
