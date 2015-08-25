//
//  PopListController.m
//  红人圈
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "PopListController.h"
#import "PopListCell.h"
#import "UserPageTableController.h"
#import "AFNetworking.h"
#import "MTLJSONAdapter.h"
#import "User.h"
#import "TradeListController.h"
#import "LoginUtil.h"

#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"

@interface PopListController ()

@end

@implementation PopListController
{
    UISearchBar *sBar;
    NSString *key;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    self.title = @"红人圈";
    
 
    [self addRight];

    dataArr = [NSMutableArray arrayWithCapacity:10];
    curPage = [NSNumber numberWithInt:1];
    
    if (uuid.length==0) {
        [LoginUtil getLocalUUID];
    }
    
    __weak PopListController *wkSelf = self;
 
    [self.tableView addPullToRefreshWithActionHandler:^{
        [wkSelf refresh];
        
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [wkSelf loadMore];
        
    }];
    
    [self loadData];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)search
{
    
    [self showHud];
    
    NSDictionary *parameters = @{
                                 @"s":key
                        
                                 };
    [dataArr removeAllObjects];
    
    [self post:@"user/json/search" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
            NSArray *arr = [dict objectForKey:@"data"];
            
            for (NSDictionary *dc in arr) {
                
                User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dc error:nil];
                [dataArr addObject:model];
                
                //NSLog(@"%@",model);
            }
            
            [self.tableView reloadData];
            
        }
        
        [self hideHud];

    }];
    
}



-(void)addRight
{
    //UIImage *searchimage=[UIImage imageNamed:@"search.png"];
    
    
//    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"左边按钮" style:UIBarButtonItemStylePlain
//                                                                      target:self action:@selector(OnLeftButton:)];
//    self.navigationItem.leftBarButtonItem = leftButtonItem;
//    [leftButtonItem release];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain
                                                                       target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
 
}

-(void)loadData
{
    [self showHud];
    
    NSDictionary *parameters = @{
                                 @"p":curPage
                                 };
    
    [self post:@"user/json/list" params:parameters success:^(id responseObj)
     {
         NSDictionary *dict = (NSDictionary *)responseObj;
         if ([[dict objectForKey:@"code"] intValue]==1) {
             NSArray *arr = [dict objectForKey:@"data"];
             for (NSDictionary *dc in arr) {
                 User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dc error:nil];
                 [dataArr addObject:model];
                 
                 //NSLog(@"%@",model);
             }
             
             [self.tableView reloadData];
             
            
             
         }
         
         [self stopAnimation];
         
     }];

}


-(void)btnBuyClick:(MyButton*)sender
{
    NSString *data = (NSString *)sender.data;
    
    TradeListController *c1 = [[TradeListController alloc] initWithNibName:@"TradeListController" bundle:nil];
    c1.fid = data;
    [self.navigationController pushViewController:c1 animated:YES];
}

-(UIView*)addSearchBar
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
    sBar = [[UISearchBar alloc] initWithFrame:view.frame];
    sBar.delegate =self;
    
    [view addSubview:sBar];
    
    
    
    return view;
}


-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    [self searchBar:self.searchBar textDidChange:nil];
    [sBar resignFirstResponder];
    
    key = searchBar.text;
    
    [self search];
}

-(void)followBuy:(UIButton*)btn
{
    NSLog(@"123");
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PopListCell";
    PopListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
 
    if (dataArr.count==0) {
        return cell;
    }
    
    User *u = (User*)[dataArr objectAtIndex:indexPath.row];
    
    cell.txtName.text = u.nickname;
    cell.txtInfo.text = u.info;
    cell.txtFollows.text = [u.followBuy stringValue];
    cell.txtTotal.text = [NSString stringWithFormat:@"%@%%",[u.totalRate stringValue]];
    cell.txtPercent.text = [NSString stringWithFormat:@"%@%%",[u.yearRate stringValue]];
    cell.btnBuy.data  = u.uuid;
    
    [cell.btnBuy addTarget:self action:@selector(btnBuyClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self addSearchBar];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  50.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PopListCell *cell = (PopListCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    User *u = (User*)[dataArr objectAtIndex:indexPath.row];
    
    UserPageTableController *controller = [[UserPageTableController alloc] initWithNibName:@"UserPageTableController" bundle:nil];
    controller.title = cell.txtName.text;
    controller.uuid = u.uuid;
    
    [self.navigationController pushViewController:controller animated:YES];
    
//    cell.btnBuy.tag  = (int)cell.txtName.text;
    
    //[cell.btnBuy addTarget:self action:@selector(followBuy:) forControlEvents:UIControlEventTouchUpInside];
}






@end
