//
//  BaseModel.h
//  touzimao
//  Model基类
//  Created by goddie on 15/8/2.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface BaseModel : MTLModel <MTLJSONSerializing>

- (void)setNilValueForKey:(NSString *)key;

+ (NSDictionary *)JSONKeyPathsByPropertyKey;

@end
