//
//  Follow.m
//  touzimao
//
//  Created by goddie on 15/9/14.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "Follow.h"

@implementation Follow
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uuid":@"id",
             @"from":@"from",
             @"sendTo":@"sendTo",
             @"status":@"status",
             @"isFan":@"isFan",
             @"isFollow":@"isFollow"
             };
}

@end
