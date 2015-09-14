//
//  UserContact.m
//  touzimao
//
//  Created by goddie on 15/9/13.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "UserContact.h"

@implementation UserContact
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uuid":@"id",
             @"user":@"user",
             @"name":@"name",
             @"phone":@"phone",
             @"phone2":@"phone2",
             @"phone3":@"phone3",
             @"contact":@"contact",
             @"isRecommend":@"isRecommend",
             @"isFan":@"isFan",
             @"isFollow":@"isFollow"
             };
}
@end