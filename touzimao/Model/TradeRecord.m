//
//  TradeRecord.m
//  touzimao
//
//  Created by goddie on 15/8/3.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "TradeRecord.h"

@implementation TradeRecord


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uuid":@"id",
             @"title":@"title",
             @"amount":@"amount",
             @"optName":@"optName",
             @"optStatus":@"optStatus",
             @"uid":@"uid",
             @"pid":@"pid",
             @"createdDate":@"createdDate",
             @"agreeBuy":@"agreeBuy",
             @"isShow":@"isShow",
             @"synBuy":@"synBuy",
             @"synSell":@"synSell",
             @"hasFans":@"hasFans"
             };
}

@end