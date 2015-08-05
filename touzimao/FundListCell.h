//
//  FundListCell.h
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface FundListCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtPercent;
@property (weak, nonatomic) IBOutlet UILabel *txtInfo;
@property (weak, nonatomic) IBOutlet UILabel *txtPercentTitle;


@property (weak, nonatomic) IBOutlet UIImageView *userImg1;
@property (weak, nonatomic) IBOutlet UIImageView *userImg2;
@property (weak, nonatomic) IBOutlet UIImageView *userImg3;

@property (weak, nonatomic) IBOutlet UILabel *userName1;
@property (weak, nonatomic) IBOutlet UILabel *userName2;
@property (weak, nonatomic) IBOutlet UILabel *userName3;


@property (weak, nonatomic) IBOutlet UILabel *userPercent1;
@property (weak, nonatomic) IBOutlet UILabel *userPercent2;
@property (weak, nonatomic) IBOutlet UILabel *userPercent3;



@end
