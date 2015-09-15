//
//  Follow.h
//  touzimao
//
//  Created by goddie on 15/9/14.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface Follow : BaseModel

@property (nonatomic, strong) NSString *uuid;
/**
 * 发起人
 */
@property (nonatomic, strong) NSDictionary *from;


/**
 * 接受人
 */
@property (nonatomic, strong) NSDictionary *sendTo;


/**
 * 0 未接受 1 已好友 2 黑名单
 */
@property (nonatomic, strong) NSNumber *status;


@property (nonatomic, strong) NSNumber *isFan;

@property (nonatomic, strong) NSNumber *isFollow;
@end
