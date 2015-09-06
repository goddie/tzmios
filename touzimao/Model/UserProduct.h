//
//  UserProduct.h
//  touzimao
//
//  Created by goddie on 15/9/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface UserProduct : BaseModel


@property (nonatomic, strong) NSString *uuid;

/**
 * 持有
 */
@property (nonatomic, strong) NSNumber *amount;

/**
 * 用户
 */
@property (nonatomic, strong) NSDictionary *user;

/**
 *  产品
 */
@property (nonatomic, strong) NSDictionary *product;


/**
 *  购买日期
 */
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


/**
 *  跟买的
 */
@property (nonatomic, strong) NSDictionary *follow;

/**
 *  有跟我的
 */
@property (nonatomic, strong) NSNumber *hasFans;

/**
 *  订单号
 */
@property (nonatomic, strong) NSString *tradeNo;

/**
 * 昨日收益
 */
@property (nonatomic, strong) NSNumber *lastIncome;

/**
 * 总收益
 */
@property (nonatomic, strong) NSNumber *totalIncome;

@end
