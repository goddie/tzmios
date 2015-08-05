//
//  PopListCell.h
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface PopListCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UILabel *txtPercent;
@property (weak, nonatomic) IBOutlet UILabel *txtInfo;
@property (weak, nonatomic) IBOutlet UILabel *txtPercentTitle;
@property (weak, nonatomic) IBOutlet UILabel *txtTotal;
@property (weak, nonatomic) IBOutlet UILabel *txtFollows;

@property (weak, nonatomic) IBOutlet UIButton *btnBuy;


@end
