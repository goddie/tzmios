//
//  ContactListController.m
//  touzimao
//  通讯录
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "ContactListController.h"
#import "TKAddressBook.h"
#import "ContactListCell.h"
#import "UserPageTableController.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "UserContact.h"
#import "Follow.h"


@interface ContactListController ()

@end

@implementation ContactListController
{
    NSMutableArray *addressBookTemp;
    NSNumber *type;
    //装UserContact
    NSMutableArray *dataArr;
    //装Follow
    NSMutableArray *dataArr2;
    NSNumber *curPage;
    UISearchBar *sBar;
    NSString *key;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"通讯录";
    type = [NSNumber numberWithInt:0];
    [self segAdd];
    
    [self addRight];
    
    addressBookTemp = [NSMutableArray array];
    NSString *isSaved = [GlobalUtil toString:[GlobalUtil getLocal:@"contact"]];
    
    if (![isSaved isEqualToString:@"1"]) {
    //if (YES) {
        [self getMyContact];
        [self updateContact];
        
        [GlobalUtil saveLocal:@"contact" value:@"1"];
    }
    

    
    
    dataArr = [NSMutableArray arrayWithCapacity:10];
    dataArr2 = [NSMutableArray arrayWithCapacity:10];
    curPage = [NSNumber numberWithInteger:1];
    
    
    __weak ContactListController *wkSelf = self;
    
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
    [dataArr2 removeAllObjects];
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


+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


-(void)updateContact
{
    NSString *uuid = [self checkLogin];
    NSMutableArray *postArr = [NSMutableArray arrayWithCapacity:10];
    
    
//    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithCapacity:10];
    
    for (TKAddressBook *book in addressBookTemp) {
        NSDictionary *dd = @{@"name":book.name,@"phone":book.tel,@"uid":uuid};
        [postArr addObject:dd];
    }
    
    if (![NSJSONSerialization isValidJSONObject:postArr])
    {
        return;
        
    }
    
 
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postArr options:NSJSONWritingPrettyPrinted error: &error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Register JSON:%@",jsonStr);
    
    
    NSDictionary *parameters = @{
                                 @"data":jsonStr,
                                 @"uid":uuid
                                 };

    NSString *url= [baseURL stringByAppendingString:@"usercontact/json/savecontact"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];

    
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    //manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接受类型不一致请替换一致text/html或别的
    
    
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    

    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        NSLog(@"Error: %@", error);
        
    }];
    
    
    
    
}


-(void)segAdd
{
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"小猫推荐",@"关注",@"粉丝",nil];
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
            type = [NSNumber numberWithInt:1];
            break;
        case 2:
            type = [NSNumber numberWithInt:2];
            break;
    }
//    [self refreshControl];
    
//    [self updateContact];
    
    [dataArr removeAllObjects];
    [dataArr2 removeAllObjects];
    [self refresh];
}

-(void)loadData
{
    NSString *uid = [self checkLogin];
    
    if ([type integerValue] ==0) {
        
        NSDictionary *parameters = @{
                                     @"p":curPage,
                                     @"uid":uid,
                                     @"type":type
                                     };
        [self showHud];
        [self post:@"usercontact/json/list" params:parameters success:^(id responseObj) {
            NSDictionary *dict = (NSDictionary *)responseObj;
            if ([[dict objectForKey:@"code"] intValue]==1) {
                NSArray *arr = [dict objectForKey:@"data"];
                
                NSError *err = nil;
                
                for (NSDictionary *dc in arr) {
                    UserContact *model = [MTLJSONAdapter modelOfClass:[UserContact class] fromJSONDictionary:dc error:&err];
                    if(model)
                    {
                        [dataArr addObject:model];
                    }
                    
                    //NSLog(@"%@",err);
                }
                
            }
            [self.tableView reloadData];
            [self stopAnimation];
        }];
        
    }
    
    if ([type integerValue] == 1||[type integerValue] == 2) {
    
        NSDictionary *parameters = @{
                                     @"p":curPage,
                                     @"uid":uid,
                                     @"type":type
                                     };
        [self showHud];
        [self post:@"follow/json/list" params:parameters success:^(id responseObj) {
            NSDictionary *dict = (NSDictionary *)responseObj;
            if ([[dict objectForKey:@"code"] intValue]==1) {
                NSArray *arr = [dict objectForKey:@"data"];
                
                NSError *err = nil;
                
                for (NSDictionary *dc in arr) {
                    
                    
                    Follow *model = [MTLJSONAdapter modelOfClass:[Follow class] fromJSONDictionary:dc error:&err];
                    if(model)
                    {
                        [dataArr2 addObject:model];
                    }
                    
                    //NSLog(@"%@",err);
                }
                
            }
            [self.tableView reloadData];
            [self stopAnimation];
        }];

    }

}


-(void)getMyContact
{
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        
    {
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
//        dispatch_release(sema);
        
    }
    
    else
        
    {
        addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
        
    }
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        TKAddressBook *addressBook = [[TKAddressBook alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.tel = (__bridge NSString*)value;
//                        NSString * strippedNumber = [addressBook.tel stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [addressBook.tel length])];
//                        
//                        addressBook.tel = strippedNumber;
                        
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [addressBookTemp addObject:addressBook];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }

}


-(void)deleteContact:(UserContact*)userContact
{
    NSString *uid = [self checkLogin];
    
//    [LoginUtil deleteFollowData:userContact.uuid];
    
    NSDictionary *parameters = @{
                                 @"cid":userContact.uuid
                                 };
    [self showHud];
    [self post:@"usercontact/json/delete" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
            
        }
        [self stopAnimation];
    }];
}


-(void)addRight
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //[btn setBackgroundImage:[UIImage imageNamed:@"iconSearch.png"] forState:UIControlStateNormal];
    [btn setTitle:@"刷新" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = right;
}

-(void)rightClick
{
    [self refresh];
}


-(void)search
{
    
    if (!key) {
        return;
    }
    
    [self showHud];
    
    NSDictionary *parameters = @{
                                 @"s":key,
                                 @"type":type
                                 };
    [dataArr removeAllObjects];
    [self post:@"usercontact/json/search" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSArray *arr = [dict objectForKey:@"data"];
            for (NSDictionary *dc in arr) {
                UserContact *model = [MTLJSONAdapter modelOfClass:[UserContact class] fromJSONDictionary:dc error:nil];
                [dataArr addObject:model];
                //NSLog(@"%@",model);
            }
            
            [self.tableView reloadData];
            
        }
        
        [self hideHud];
        
    }];
    
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //    [self searchBar:self.searchBar textDidChange:nil];
    [sBar resignFirstResponder];
    
    key = searchBar.text;
    
    [self search];
}

-(UIView*)addSearchBar
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
    sBar = [[UISearchBar alloc] initWithFrame:view.frame];
    sBar.delegate =self;
    
    [view addSubview:sBar];
    
    
    
    return view;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    if ([type integerValue]==0) {
         return dataArr.count;
    }
    return dataArr2.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([type integerValue]==0) {
    
        static NSString *CellIdentifier = @"ContactListCell";
        ContactListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        UserContact *userContact = (UserContact*)[dataArr objectAtIndex:indexPath.row];
        User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:userContact.contact error:nil];
        
        
        if (user.totalRate) {
            NSString *str = [NSString stringWithFormat:@"%.f%%",[user.totalRate floatValue] * 100];
            cell.txtPercent.text = str;
        }
        
        //TKAddressBook *book = [addressBookTemp objectAtIndex:indexPath.row];
        cell.txtName.text = [NSString stringWithFormat:@"%@ (%@)",userContact.name,user.nickname];
        if (user.avatar) {
            NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:user.avatar]];
            [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"avatar.png"]];
        }
        
        
        NSInteger isFan  = [userContact.isFan integerValue];
        NSInteger isFollow = [userContact.isFollow integerValue];
        
        //互不关注
        if (isFan==0 && isFollow==0) {
            cell.img2.image = [UIImage imageNamed:@"iconContact3.png"];
        }
        
        //互相关注
        if (isFan==1 && isFollow==1) {
            cell.img2.image = [UIImage imageNamed:@"iconContact1.png"];
        }
        
        //关注我
        if (isFan==1 && isFollow==0) {
            cell.img2.image = [UIImage imageNamed:@"iconContact2.png"];
        }
        
        //被我关注
        if (isFan==0 && isFollow==1) {
            cell.img2.image = [UIImage imageNamed:@"iconContact4.png"];
        }

        return cell;
    }
    
    static NSString *CellIdentifier = @"ContactListCell";
    ContactListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Follow *follow = (Follow*)[dataArr2 objectAtIndex:indexPath.row];
    
    
    User *user;
    if ([type integerValue]==1) {
        user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:follow.sendTo error:nil];
    }
    
    if ([type integerValue]==2) {
        user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:follow.from error:nil];
    }
    
    if (user.totalRate) {
        NSString *str = [NSString stringWithFormat:@"%.f%%",[user.totalRate floatValue] * 100];
        cell.txtPercent.text = str;
    }
    
    //TKAddressBook *book = [addressBookTemp objectAtIndex:indexPath.row];
    cell.txtName.text = [NSString stringWithFormat:@"%@",user.nickname];
    if (user.avatar) {
        NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:user.avatar]];
        [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"avatar.png"]];
    }
    
    NSInteger isFan = [follow.isFan integerValue];
    NSInteger isFollow = [follow.isFollow integerValue];
    
    //互不关注
    if (isFan==0 && isFollow==0) {
        cell.img2.image = [UIImage imageNamed:@"iconContact3.png"];
    }
    
    //互相关注
    if (isFan==1 && isFollow==1) {
        cell.img2.image = [UIImage imageNamed:@"iconContact1.png"];
    }
    
    //关注我
    if (isFan==1 && isFollow==0) {
        cell.img2.image = [UIImage imageNamed:@"iconContact2.png"];
    }
    
    //被我关注
    if (isFan==0 && isFollow==1) {
        cell.img2.image = [UIImage imageNamed:@"iconContact4.png"];
    }

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactListCell *cell = (ContactListCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([type integerValue]==0) {
        UserContact *userContact = (UserContact*)[dataArr objectAtIndex:indexPath.row];
        User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:userContact.contact error:nil];
        
        //    User *user  = [dataArr objectAtIndex:indexPath.row];
        
        UserPageTableController *controller = [[UserPageTableController alloc] initWithNibName:@"UserPageTableController" bundle:nil];
        controller.title = cell.txtName.text;
        controller.uuid = user.uuid;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    Follow *follow = (Follow*)[dataArr2 objectAtIndex:indexPath.row];
    
    User *user;
    if ([type integerValue]==1) {
        user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:follow.sendTo error:nil];
    }
    
    if ([type integerValue]==2) {
        user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:follow.from error:nil];
    }

    
 
    
//    User *user  = [dataArr objectAtIndex:indexPath.row];

    UserPageTableController *controller = [[UserPageTableController alloc] initWithNibName:@"UserPageTableController" bundle:nil];
    controller.title = cell.txtName.text;
    controller.uuid = user.uuid;
    [self.navigationController pushViewController:controller animated:YES];
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UserContact *userContact = (UserContact*)[dataArr objectAtIndex:indexPath.row];
        User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:userContact.contact error:nil];

        
        //User *user  = [dataArr objectAtIndex:indexPath.row];
        [self deleteContact:userContact];
        
        [dataArr removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        

    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self addSearchBar];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  50.0f;
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
