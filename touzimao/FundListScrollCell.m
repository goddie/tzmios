//
//  FundListCell.m
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "FundListScrollCell.h"
#import "UIImageView+WebCache.h"
#import "MyButton.h"

@implementation FundListScrollCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)addUser:(NSArray *)userArr
{
    int x = 0;
    
    for (int i=0; i<userArr.count; i++) {
        
        User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:[userArr objectAtIndex:i] error:nil];
        
        
        x = 120 * i + 8 * (i+1);
        
        UIView *holder=  [[UIView alloc] initWithFrame:CGRectMake(x, 5, 120, 40)];

        //holder.backgroundColor = [UIColor redColor];
        
        [self.scrollView addSubview:holder];
        
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
        [img setImage:[UIImage imageNamed:@"avatar.png"]];
        if(model.avatar)
        {
            NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:model.avatar]];
            [img sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"avatar.png"]];
        }
        
        [GlobalUtil setMaskImageQuick:img withMask:@"mask.png" point:CGPointMake(30.0f, 30.0f)];
        [holder addSubview:img];
        
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 85, 20)];
        [name setFont:[UIFont systemFontOfSize:12.0f]];
        //name.backgroundColor = [UIColor greenColor];
        name.text = model.nickname;
        [holder addSubview:name];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(35, 20, 50, 20)];
        [title setFont:[UIFont systemFontOfSize:12.0f]];
        title.text = @"昨日收益";
        //title.backgroundColor = [UIColor yellowColor];
        [holder addSubview:title];
        
        
        UILabel *per = [[UILabel alloc] initWithFrame:CGRectMake(85, 20, 35, 20)];
        [per setFont:[UIFont systemFontOfSize:12.0f]];
        per.text =[NSString stringWithFormat:@"%@%%",[GlobalUtil toString:model.lastIncome]];
        //per.backgroundColor = [UIColor yellowColor];
        [holder addSubview:per];
        
        [GlobalUtil addButtonToView:self sender:holder action:@selector(openUser:) data:model.uuid];
    }
    
    //self.scrollView.backgroundColor = [UIColor yellowColor];
    self.scrollView.contentSize = CGSizeMake(x+120+8, 0);
    // 滚动条不显示
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
 

}


-(void)openUser:(MyButton*)sender;
{
    NSString *str = (NSString*)sender.data;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openUser" object:str];
    
}


@end
