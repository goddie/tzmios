//
//  BaseModel.m
//  touzimao
//
//  Created by goddie on 15/8/2.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "BaseModel.h"


@implementation BaseModel

- (void)setNilValueForKey:(NSString *)key {
    [self setValue:@0 forKey:key]; // For NSInteger/CGFloat/BOOL
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}



@end
