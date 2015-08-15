//
//  MyFansController.m
//  touzimao
//
//  Created by goddie on 15/8/11.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "MyFansController.h"
#import "AFNetworking.h"
#import "MTLJSONAdapter.h"
#import "User.h"
#import "LoginUtil.h"

@interface MyFansController ()

@end

@implementation MyFansController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadData
{
    
    if (uuid.length==0) {
       uuid = [LoginUtil getLocalUUID];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"p":curPage,
                                 @"uid": uuid,
                                 @"pid":self.pid
                                 };
    [manager POST:[GlobalUtil requestURL:@"traderecord/json/fanlist"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSArray *arr = [dict objectForKey:@"data"];
            for (NSDictionary *dc in arr) {
                
                NSDictionary *dc2 = [dc objectForKey:@"user"];
                if (![dc2 isEqual:[NSNull null]]){
                    
                    
                    User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dc2 error:nil];
                    [dataArr addObject:model];
                    
                    
                }

            }
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  0;
}


@end
