//
//  Message.m
//  touzimao
//
//  Created by goddie on 15/8/4.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "Message.h"

@implementation Message


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uuid":@"id",
             @"from":@"from",
             @"sendTo":@"sendTo",
             @"content":@"content",
             @"createdDate":@"createdDate"
             };
}



@end
