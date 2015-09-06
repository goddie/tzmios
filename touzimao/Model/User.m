//
//  User.m
//  touzimao
//
//  Created by goddie on 15/8/2.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "User.h"

@implementation User


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uuid":@"id",
             @"nickname":@"nickname",
             @"level":@"level",
             @"wealth":@"wealth",
             @"totalRate":@"totalRate",
             @"yearRate":@"yearRate",
             @"followBuy":@"followBuy",
             @"avatar":@"avatar",
             @"info":@"info",
             @"phone":@"phone",
             @"weichat":@"weichat",
             @"weibo":@"weibo",
             @"totalIncome":@"totalIncome",
             @"lastIncome":@"lastIncome",
             @"username":@"username",
             @"password":@"password",
             @"email":@"email",
             @"regIp":@"regIp",
             @"catCoin":@"catCoin",
             @"score":@"score"
             };
}


@end

