//
//  GlobalConst.m
//  Bullfight
//
//  Created by goddie on 15/6/30.
//  Copyright (c) 2015年 goddie. All rights reserved.
//

#import "GlobalConst.h"

@implementation GlobalConst

NSString *const baseURL = @"http://localhost:8080/Test/"; //localhost:8080/touzimao 101.200.235.199:8080/Test

+(UIColor *)tabTintColor
{
    return [UIColor colorWithRed:226.0f/255.0f green:61.0f/255.0f blue:68.0f/255.0f alpha:1.0];
}

+(UIColor *)tabBgColor
{
    return [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1.0];
}

+(UIColor *)bgRed
{
    return [UIColor colorWithRed:215.0f/255.0f green:34.0f/255.0f blue:49.0f/255.0f alpha:1.0];
}



@end
