//
//  SysConfigController.m
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "SysConfigController.h"
#import "ConfigCell.h"
#import "AccountController.h"
#import "WebPageController.h"

@interface SysConfigController ()

@end

@implementation SysConfigController
{
    NSArray *buttons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"更多";
    
    buttons =[ NSArray arrayWithObjects:@"账户管理",@"邀请好友",@"客户服务",@"常见问答",@"关于投资猫", nil];
    
    UIView *v = [UIView new];
    self.tableView.tableFooterView = v;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return buttons.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ConfigCell";
    ConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.txtName.text = [buttons objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ConfigCell *cell = (ConfigCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row==0) {
        
        AccountController *controller = [[AccountController alloc] initWithNibName:@"AccountController" bundle:nil];
        controller.user = self.user;
        
        [self.navigationController pushViewController:controller animated:YES];
        
        return;
    }
    
    if (indexPath.row==2) {
        NSString *url = [baseURL stringByAppendingString:@"article/page/detail?title=客户服务"];
        WebPageController *c1 = [[WebPageController alloc] initWithNibName:@"WebPageController" bundle:nil];
        c1.title = cell.txtName.text;
        c1.URL =url;
        [self.navigationController pushViewController:c1 animated:YES];
    }
    
    if (indexPath.row==3) {
        NSString *url = [baseURL stringByAppendingString:@"article/page/detail?title=常见问答"];
        WebPageController *c1 = [[WebPageController alloc] initWithNibName:@"WebPageController" bundle:nil];
        c1.title = cell.txtName.text;
        c1.URL =url;
        [self.navigationController pushViewController:c1 animated:YES];
    }
    
    if (indexPath.row==4) {
        NSString *url = [baseURL stringByAppendingString:@"article/page/detail?title=关于投资猫"];
        WebPageController *c1 = [[WebPageController alloc] initWithNibName:@"WebPageController" bundle:nil];
        c1.title = cell.txtName.text;
        c1.URL =url;
        [self.navigationController pushViewController:c1 animated:YES];
    }


}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
