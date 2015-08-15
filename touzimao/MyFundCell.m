//
//  MyFundCell.m
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "MyFundCell.h"

@implementation MyFundCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)isOpen:(NSInteger)open
{
    if (open==1) {
        [self.btnIsOpen setBackgroundImage:[UIImage imageNamed:@"iconChecked.png"] forState:UIControlStateNormal];
    }
    
    if (open==0) {
        [self.btnIsOpen setBackgroundImage:[UIImage imageNamed:@"iconUnChecked.png"] forState:UIControlStateNormal];
    }
}
@end
