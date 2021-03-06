//
//  TradeListController.m
//  touzimao
//  交易记录
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "TradeListController.h"
#import "TradeListCell.h"
#import "AFNetworking.h"
#import "LoginUtil.h"
#import "TradeRecord.h"
#import "FundDetailController.h"
#import "Product.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"

@interface TradeListController ()

@end

@implementation TradeListController
{
    NSNumber *curPage;
    NSMutableArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"交易明细";
    
    curPage = [NSNumber numberWithInt:1];
    dataArr = [NSMutableArray arrayWithCapacity:10];
    
    if (self.uuid.length==0) {
        self.uuid = [LoginUtil getLocalUUID];
    }
    
    
    __weak TradeListController *wkSelf = self;
    
 
    [self.tableView addPullToRefreshWithActionHandler:^{
        [wkSelf refresh];
        
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [wkSelf loadMore];
        
    }];
    
    [self loadData];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)refresh
{
    [dataArr removeAllObjects];
    curPage = [NSNumber numberWithInt:1];
    [self loadData];
}

-(void)loadMore
{
    curPage = [NSNumber numberWithInt: [curPage intValue] + 1];
    
    [self loadData];
}

-(void)stopAnimation
{
    [self.tableView.pullToRefreshView stopAnimating];
    [self.tableView.infiniteScrollingView stopAnimating];
    [self hideHud];
}




-(void)loadData
{
    [self showHud];
    
    NSDictionary *parameters = @{
                                 @"uid":self.uuid,
                                 @"p":[curPage stringValue]
                                 };
    
    [self post:@"traderecord/json/list" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            NSArray *arr = [dict objectForKey:@"data"];
            
            for (NSDictionary *dc in arr) {
                
                NSDictionary *dc2 = [dc objectForKey:@"product"];
                
                TradeRecord *model = [MTLJSONAdapter modelOfClass:[TradeRecord class] fromJSONDictionary:dc error:nil];
                
                if (![dc2 isEqual:[NSNull null]]) {
                    
                    Product *p= [MTLJSONAdapter modelOfClass:[Product class] fromJSONDictionary:dc2 error:nil];
                    model.pid = p.uuid;
                }
                
                [dataArr addObject:model];
                
                //NSLog(@"%@",model);
            }
            
            [self.tableView reloadData];
        }
        
        [self stopAnimation];

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
    static NSString *CellIdentifier = @"TradeListCell";
    TradeListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (dataArr.count==0) {
        return cell;
    }
    
    TradeRecord *model = [dataArr objectAtIndex:indexPath.row];

    cell.txtName.text = model.title;
    cell.txtDate.text = [GlobalUtil getDateFromUNIX: model.createdDate];
    cell.txtOpt.text = model.optName;
    cell.txtStatus.text = model.optStatus;
    cell.txtAmount.text = [model.amount stringValue];
    cell.txtTradeNo.text  = [NSString stringWithFormat:@"单号:%@",model.tradeNo];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 117.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //TradeListCell *cell = (TradeListCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    TradeRecord *model = [dataArr objectAtIndex:indexPath.row];
    
    FundDetailController *c1 = [[FundDetailController alloc] initWithNibName:@"FundDetailController" bundle:nil];
    c1.uuid = model.pid;
    c1.title = model.title;
    c1.fid = self.fid;
    [self.navigationController pushViewController:c1 animated:YES];
}


@end
