//
//  UserIntroduce.m
//  touzimao
//
//  Created by goddie on 15/9/12.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "UserIntroduce.h"

@interface UserIntroduce ()

@end

@implementation UserIntroduce

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.txt1.text = @"";
    self.txt1.text = self.content;
    
    self.title = @"个人介绍";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 

@end
