//
//  Product.m
//  touzimao
//
//  Created by goddie on 15/8/3.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "Product.h"

@implementation Product


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uuid":@"id",
             @"name":@"name",
             @"finished":@"finished",
             @"yearRate":@"yearRate",
             @"weekRate":@"weekRate",
             @"cycle":@"cycle",
             @"status":@"status",
             @"ensure":@"ensure",
             @"goalCapital":@"goalCapital",
             @"risk":@"risk",
             @"payType":@"payType",
             @"fee":@"fee",
             @"url":@"url",
             @"productType":@"productType",
             @"tenThousand":@"tenThousand",
             @"minBuy":@"minBuy",
             @"timeLimit":@"timeLimit",
             @"cashTime":@"cashTime",
             @"notice":@"notice",
             @"info":@"info",
             @"pubDate":@"pubDate",
             @"code":@"code"
             };
}



@end