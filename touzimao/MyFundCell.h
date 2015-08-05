//
//  MyFundCell.h
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFundCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtYesterday;

@property (weak, nonatomic) IBOutlet UILabel *txtMyFollow;
@property (weak, nonatomic) IBOutlet UIImageView *imgOpen;
@property (weak, nonatomic) IBOutlet UILabel *txtHold;

@property (weak, nonatomic) IBOutlet UILabel *txtIncome;

@property (weak, nonatomic) IBOutlet UILabel *txtTotal;

@property (weak, nonatomic) IBOutlet UILabel *txtNearBy;

@property (weak, nonatomic) IBOutlet UILabel *txtFollowMe;


@end
