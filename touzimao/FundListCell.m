//
//  FundListCell.m
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "FundListCell.h"

@implementation FundListCell

- (void)awakeFromNib {
    // Initialization code
    
    CALayer *mask1 = [CALayer layer];
    mask1.contents = (id)[[UIImage imageNamed:@"mask.png"] CGImage];
    mask1.frame = CGRectMake(0, 0, 24, 24);
    
    CALayer *mask2 = [CALayer layer];
    mask2.contents = (id)[[UIImage imageNamed:@"mask.png"] CGImage];
    mask2.frame = CGRectMake(0, 0, 24, 24);
    
    
    CALayer *mask3 = [CALayer layer];
    mask3.contents = (id)[[UIImage imageNamed:@"mask.png"] CGImage];
    mask3.frame = CGRectMake(0, 0, 24, 24);
    
    self.userImg1.layer.mask = mask1;
    self.userImg1.layer.masksToBounds = YES;
    self.userImg1.image = [UIImage imageNamed:@"holder.png"];
    
    self.userImg2.layer.mask = mask2;
    self.userImg2.layer.masksToBounds = YES;
    self.userImg2.image = [UIImage imageNamed:@"holder.png"];
    
    self.userImg3.layer.mask = mask3;
    self.userImg3.layer.masksToBounds = YES;
    self.userImg3.image = [UIImage imageNamed:@"holder.png"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
