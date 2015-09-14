//
//  UserProduct.m
//  touzimao
//
//  Created by goddie on 15/9/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "UserProduct.h"

@implementation UserProduct


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uuid":@"id",
             @"amount":@"amount",
             @"user":@"user",
             @"product":@"product",
             @"createdDate":@"createdDate",
             @"agreeBuy":@"agreeBuy",
             @"isShow":@"isShow",
             @"synBuy":@"synBuy",
             @"synSell":@"synSell",
             @"follow":@"follow",
             @"hasFans":@"hasFans",
             @"tradeNo":@"tradeNo",
             @"lastIncome":@"lastIncome",
             @"totalIncome":@"totalIncome"
             };
}
@end
