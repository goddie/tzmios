//
//  UserProductList.m
//  touzimao
//  投资组合

//  Created by goddie on 15/9/12.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "UserProductList.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "UserProduct.h"
#import "Product.h"
#import "TradeListCell.h"
#import "FundDetailController.h"

@interface UserProductList ()

@end

@implementation UserProductList
{
    NSNumber *curPage;
    NSMutableArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"投资历史";
    
    if ([self.status intValue]==1) {
        self.title = @"正投资产品";
    }
    
    
    curPage = [NSNumber numberWithInt:1];
    dataArr = [NSMutableArray arrayWithCapacity:10];
    
    
    
    __weak UserProductList *wkSelf = self;
    
    
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
    
    if (!self.uid) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid":self.uid,
                                 @"p":[curPage stringValue],
                                 @"status":self.status
                                 };
    [self showHud];
    [self post:@"userproduct/json/mylist" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            NSArray *arr = [dict objectForKey:@"data"];
            
            for (NSDictionary *dc in arr) {
                UserProduct *model = [MTLJSONAdapter modelOfClass:[UserProduct class] fromJSONDictionary:dc error:nil];
                
//                NSDictionary *dc2 = [dc objectForKey:@"product"];
//                if (![dc2 isEqual:[NSNull null]]) {
//                    Product *p= [MTLJSONAdapter modelOfClass:[Product class] fromJSONDictionary:dc2 error:nil];
//                }
                
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
    
    UserProduct *model = [dataArr objectAtIndex:indexPath.row];
    
    Product *p= [MTLJSONAdapter modelOfClass:[Product class] fromJSONDictionary:model.product error:nil];
    
    
    cell.txtName.text = p.CPMC;
    cell.txtDate.text = [GlobalUtil getDateFromUNIX: model.createdDate];
    
    cell.txtOpt.hidden = YES;
    cell.txtStatus.hidden = YES;
    //cell.txtOpt.text = model.optName;
    //cell.txtStatus.text = model.optStatus;
    cell.txtAmount.text = [GlobalUtil toString:model.amount];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
    
    UserProduct *model = [dataArr objectAtIndex:indexPath.row];
    Product *p= [MTLJSONAdapter modelOfClass:[Product class] fromJSONDictionary:model.product error:nil];
    
    FundDetailController *c1 = [[FundDetailController alloc] initWithNibName:@"FundDetailController" bundle:nil];
    c1.uuid = p.uuid;
    c1.title = p.CPMC;
//    c1.fid = p.uuid;
    [self.navigationController pushViewController:c1 animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
