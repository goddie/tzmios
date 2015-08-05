//
//  PopListCell.m
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "PopListCell.h"
#import "FundDetailController.h"

@implementation PopListCell

- (void)awakeFromNib {
    // Initialization code
    
    
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[[UIImage imageNamed:@"mask.png"] CGImage];
    mask.frame = CGRectMake(0, 0, 32, 32);
    
    self.img1.layer.mask = mask;
    self.img1.layer.masksToBounds = YES;
    self.img1.image = [UIImage imageNamed:@"header.png"];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end