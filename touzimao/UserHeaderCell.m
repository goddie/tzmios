//
//  UserHeaderCell.m
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "UserHeaderCell.h"

@implementation UserHeaderCell

- (void)awakeFromNib {
    // Initialization code
    
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[[UIImage imageNamed:@"mask.png"] CGImage];
    mask.frame = CGRectMake(0, 0, 60, 60);
    
    self.img.layer.mask = mask;
    self.img.layer.masksToBounds = YES;
    self.img.image = [UIImage imageNamed:@"avatar.png"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
