//
//  FundListController.m
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "FundListController.h"
#import "FundListCell.h"
#import "FundListScrollCell.h"
#import "FundDetailController.h"
#import "AFNetworking.h"
#import "MTLJSONAdapter.h"
#import "Product.h"
#import "User.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "MyButton.h"
#import "UserPageTableController.h"

@interface FundListController ()

@end

@implementation FundListController
{
    NSMutableArray *dataArr;
    NSNumber *curPage;
    NSNumber *type;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openCellUser:) name:@"openUser"object:nil];
    
    [self globalConfig];
    
    self.title = @"聚宝盆";
    
    [self segAdd];
    
    dataArr = [NSMutableArray arrayWithCapacity:10];
    curPage = [NSNumber numberWithInt:1];
    type = [NSNumber numberWithInt:0];
    
    __weak FundListController *wkSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [wkSelf refresh];
        
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [wkSelf loadMore];
        
    }];
    
    [self loadData];

}

//-(void)hudInit
//{
//    hud = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:hud];
//    hud.mode = MBProgressHUDModeText;
//    hud.delegate = self;
//    hud.labelText = @"Loading";
//}

-(void)openCellUser:(NSNotification*)notification
{
    NSString *uuid = (NSString*)notification.object;
    UserPageTableController *c1 = [[UserPageTableController alloc] initWithNibName:@"UserPageTableController" bundle:nil];
    c1.uuid =uuid;
    [self.navigationController pushViewController:c1 animated:YES];
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



-(void)segAdd
{
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"小猫推荐",@"高风险",@"低风险",nil];
    //初始化UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    //segmentedControl.frame = CGRectMake(1.0, [UIScreen mainScreen].bounds.size.height-50-64, 318.0, 30.0);
    segmentedControl.frame = CGRectMake(0, 0, 240.0f, 30.0f);
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    //[segmentedControl setBackgroundImage:[UIImage imageNamed:@"zyyy_choose_middle.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //[segmentedControl setBackgroundImage:[UIImage imageNamed:@"zyyy_choose_middle_touch.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    //segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;//设置样式
    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
    [self.view addSubview:segmentedControl];
    
    self.navigationItem.titleView = segmentedControl;
}


-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    //NSLog(@"Index %d", Index);
    
    switch (Index) {
            
        case 0:
            type = [NSNumber numberWithInt:0];
            
            break;
        case 1:
            type = [NSNumber numberWithInt:2];
            break;
        case 2:
            type = [NSNumber numberWithInt:1];
            break;
    }
    [self refresh];
}

-(void)loadData
{

    
    [self showHud];
    
    NSDictionary *parameters = @{
                                 @"p":curPage,
                                 @"type":type
                                 };
    
    [self post:@"product/json/list" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
            NSArray *arr = [dict objectForKey:@"data"];
            
            for (NSDictionary *dc in arr) {
                //NSLog(@"%@",dc);
                
                Product *model = [MTLJSONAdapter modelOfClass:[Product class] fromJSONDictionary:dc error:nil];
                
                if (model!=NULL) {
                    [dataArr addObject:model];
                }
                
            }
            
            [self.tableView reloadData];
            
        }
        
        [self stopAnimation];
        
        
    }];
    
    
}


-(void)openUser:(id)sender
{
    MyButton *btn = (MyButton*)sender;
    User *data = (User*)btn.data;
    UserPageTableController *c1 = [[UserPageTableController alloc] initWithNibName:@"UserPageTableController" bundle:nil];
    c1.uuid = data.uuid;
    
    [self.navigationController pushViewController:c1 animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FundListScrollCell";
    FundListScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (dataArr.count==0) {
        return cell;
    }
    
    Product *p = (Product*)[dataArr objectAtIndex:indexPath.row];
    

    
    cell.txtName.text = p.CPJC;
    
    float per = [p.SYLZG floatValue] / 100.0f;
    cell.txtPercent.text= [NSString stringWithFormat:@"%.1f%%",per];
    cell.txtInfo.text = [NSString stringWithFormat:@"%@ %@ 起购金额:%@",p.CPBH,[p.CPQX stringValue],[p.TZMKED stringValue]];
    
    NSArray *arr = p.list;
    
    if(arr.count==0)
    {
        return cell;
    }
    
    
    [cell addUser:arr];
    
//    if (arr.count==1) {
//        User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:[arr objectAtIndex:0] error:nil];
//        if(model.avatar)
//        {
//            NSURL *imagePath2 = [NSURL URLWithString:model.avatar];
//            [cell.userImg1 sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
//        }
//
//        cell.userName1.text = model.nickname;
//        cell.userPercent1.text = [model.lastIncome stringValue];
//        cell.txtPercentTitle.text = @"最高收益";
//        
//        [GlobalUtil addButtonToView:self sender:cell.view1 action:@selector(openUser:) data:model.uuid];
//        
//        cell.view2.hidden=YES;
//        cell.view3.hidden=YES;
//    }
//    
//    if (arr.count==2) {
//        User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:[arr objectAtIndex:1] error:nil];
//        if(model.avatar)
//        {
//            NSURL *imagePath2 = [NSURL URLWithString:model.avatar];
//            [cell.userImg1 sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
//        }
//        
//        cell.userName2.text = model.nickname;
//        cell.userPercent2.text = [model.lastIncome stringValue];
//        
//        [GlobalUtil addButtonToView:self sender:cell.view2 action:@selector(openUser:) data:model.uuid];
//        
//        cell.view3.hidden=YES;
//    }
//    
//    if (arr.count==3) {
//        User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:[arr objectAtIndex:2] error:nil];
//        if(model.avatar)
//        {
//            NSURL *imagePath2 = [NSURL URLWithString:model.avatar];
//            [cell.userImg1 sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
//        }
//        
//        cell.userName3.text = model.nickname;
//        cell.userPercent3.text = [model.lastIncome stringValue];
//        [GlobalUtil addButtonToView:self sender:cell.view3 action:@selector(openUser:) data:model.uuid];
//    }
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FundListCell *cell = (FundListCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    Product *p = (Product*)[dataArr objectAtIndex:indexPath.row];

    
    FundDetailController *controller = [[FundDetailController alloc] initWithNibName:@"FundDetailController" bundle:nil];
    controller.uuid = p.uuid;
    controller.title = cell.txtName.text;
    [self.navigationController pushViewController:controller animated:YES];
    
   
}



@end
