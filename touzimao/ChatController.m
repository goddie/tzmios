//
//  ChatController.m
//  touzimao
//
//  Created by goddie on 15/8/4.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "ChatController.h"
#import "AFNetworking.h"
#import "MTLJSONAdapter.h"
#import "Message.h"
#import "ChatCell.h"
#import "User.h"
#import "ChatSendController.h"

@interface ChatController ()

@end

@implementation ChatController
{
    NSMutableArray *dataArr;
    NSNumber *curPage;
    ChatSendController *footer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聊天";
    
    footer = [[ChatSendController alloc] initWithNibName:@"ChatSendController" bundle:nil];
    
    [footer.btn1 addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addChildViewController:footer];
    
    dataArr = [NSMutableArray arrayWithCapacity:10];
    curPage = [NSNumber numberWithInt:1];
    [self loadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)sendClick
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"content":footer.txt1.text,
                                 @"from":self.from,
                                 @"sendTo":self.sendTo
                                 };
    [manager POST:[GlobalUtil requestURL:@"message/json/add"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            [self.tableView reloadData];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)loadData
{
    [dataArr removeAllObjects];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"p":curPage,
                                 @"from":self.from,
                                 @"sendTo":self.sendTo
                                 };
    [manager POST:[GlobalUtil requestURL:@"message/json/getmsg"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
            NSArray *arr = [dict objectForKey:@"data"];
            
            for (NSDictionary *dc in arr) {
                //NSLog(@"%@",dc);
                NSDictionary *dc1 = [dc objectForKey:@"from"];
                User *u1 = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dc1 error:nil];
                
                NSDictionary *dc2 = [dc objectForKey:@"sendTo"];
                User *u2 = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dc2 error:nil];
                
                
                Message *model = [MTLJSONAdapter modelOfClass:[Message class] fromJSONDictionary:dc error:nil];
                
                if (model!=NULL) {
                    
                    model.from = u1.nickname;
                    model.sendTo = u2.nickname;
                    
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
    static NSString *CellIdentifier = @"ChatCell";
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Message *p = (Message*)[dataArr objectAtIndex:indexPath.row];
    
    cell.txtNick.text = p.from;
    cell.txtDate.text = [GlobalUtil getDateFromUNIX: p.createdDate];
    cell.txtContent.text = p.content;
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return footer.view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.0f;
}


@end
