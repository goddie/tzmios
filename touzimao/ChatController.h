//
//  ChatController.h
//  touzimao
//
//  Created by goddie on 15/8/4.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString *from;

@property (nonatomic, strong) NSString *sendTo;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *botView;

@end
