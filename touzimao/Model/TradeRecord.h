//
//  TradeRecord.h
//  touzimao
//
//  Created by goddie on 15/8/3.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"


@interface TradeRecord : BaseModel

@property (nonatomic, strong) NSString *uuid;

/**
 * 记录标题
 */
@property (nonatomic, strong) NSString *title;

/**
 * 资金量
 */
@property (nonatomic, strong) NSNumber *amount;

/**
 * 操作名称
 */
@property (nonatomic, strong) NSString *optName;

/**
 * 操作状态
 */
@property (nonatomic, strong) NSString *optStatus;

/**
 * 用户
 */
@property (nonatomic, strong) NSString *uid;

@property (nonatomic, strong) NSString *pid;

@property (nonatomic, strong) NSNumber *createdDate;

/**
 * 同意购买
 */
@property (nonatomic, strong) NSNumber *agreeBuy;

/**
 * 公开收益
 */
@property (nonatomic, strong) NSNumber *isShow;

/**
 * 同步买入
 */
@property (nonatomic, strong) NSNumber *synBuy;

/**
 * 同步卖出
 */
@property (nonatomic, strong) NSNumber *synSell;
@end
