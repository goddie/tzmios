//
//  EnterController.m
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "EnterController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "LoginUtil.h"
#import "User.h"

@interface EnterController ()

@end

@implementation EnterController
{
    NSString *uuid;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[[UIImage imageNamed:@"mask.png"] CGImage];
    mask.frame = CGRectMake(0, 0, 80, 80);
    
    self.img1.layer.mask = mask;
    self.img1.layer.masksToBounds = YES;
    self.img1.image = [UIImage imageNamed:@"header.png"];
    
    uuid = [LoginUtil getLocalUUID];
    
    if (uuid.length>0) {
        [self loadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 };
    [manager POST:[GlobalUtil requestURL:@"user/json/advice"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
            NSDictionary *dc = [dict objectForKey:@"data"];
            
            
            User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dc error:nil];
            
            self.txt1.text = model.nickname;
            self.txt2.text = [NSString stringWithFormat:@"%@",[model.lastIncome stringValue]];
            
            self.uuid = model.uuid;
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (IBAction)btn1Click:(id)sender {
    
    if (self.uuid.length>0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openAdvise" object:self.uuid];
    }
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate changeRoot];
}


- (IBAction)btn2Click:(id)sender {
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate changeRoot];
}




@end
