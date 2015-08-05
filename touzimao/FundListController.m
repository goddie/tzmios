//
//  FundListController.m
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "FundListController.h"
#import "FundListCell.h"
#import "FundDetailController.h"
#import "AFNetworking.h"
#import "MTLJSONAdapter.h"
#import "Product.h"

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
    
    //self.title = @"聚宝盆";
    
    [self segAdd];
    
    dataArr = [NSMutableArray arrayWithCapacity:10];
    curPage = [NSNumber numberWithInt:1];
    type = [NSNumber numberWithInt:0];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self loadData];
}

-(void)loadData
{
    [dataArr removeAllObjects];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"p":curPage,
                                 @"type":type
                                 };
    [manager POST:[GlobalUtil requestURL:@"product/json/list"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
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
    static NSString *CellIdentifier = @"FundListCell";
    FundListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Product *p = (Product*)[dataArr objectAtIndex:indexPath.row];
    
    cell.txtName.text = p.name;
    cell.txtPercent.text= [NSString stringWithFormat:@"%@%%",[p.weekRate stringValue]];
    cell.txtInfo.text = [NSString stringWithFormat:@"%@ %@ 起购金额:%@",p.code,[GlobalUtil getDateFromUNIX:p.pubDate],[p.minBuy stringValue]];
    
    
    
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
