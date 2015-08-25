//
//  MyPageController.h
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MyPageController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtLevel;
@property (weak, nonatomic) IBOutlet UILabel *txtWealth;
@property (weak, nonatomic) IBOutlet UILabel *txtTotal;
@property (weak, nonatomic) IBOutlet UILabel *txtYesterday;


@property (strong,nonatomic) User *user;

@end
