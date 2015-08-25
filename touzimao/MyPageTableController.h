//
//  MyPageTableController.h
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MyPageTableController : UITableViewController

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) User *user;
@end
