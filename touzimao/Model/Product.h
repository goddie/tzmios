//
//  Product.h
//  touzimao
//
//  Created by goddie on 15/8/3.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Product  : BaseModel


@property (nonatomic, strong) NSString *uuid;
/**
 * 名称
 */
@property (nonatomic, strong) NSString *name;

/**
 * 完成度
 */
@property (nonatomic, strong) NSNumber *finished;

/**
 * 年化收益
 */
@property (nonatomic, strong) NSNumber *yearRate;


/**
 * 7日收益
 */
@property (nonatomic, strong) NSNumber *weekRate;

/**
 * 投资周期
 */
@property (nonatomic, strong) NSNumber *cycle;

/**
 * 产品状态
 */
@property (nonatomic, strong) NSNumber *status;



/**
 * 担保方
 */
@property (nonatomic, strong) NSString *ensure;


/**
 * 募集资金
 */
@property (nonatomic, strong) NSNumber *goalCapital;

/**
 * 风险等级
 */
@property (nonatomic, strong) NSString *risk;



/**
 * 回款方式
 */
@property (nonatomic, strong) NSString *payType;

/**
 * 手续费率
 */
@property (nonatomic, strong) NSNumber *fee;


/**
 * 介绍网页
 */
@property (nonatomic, strong) NSString *url;


/**
 * 产品类型
 */
@property (nonatomic, strong) NSNumber *productType;


/**
 * 万份收益
 */
@property (nonatomic, strong) NSNumber *tenThousand;

/**
 * 起购金额
 */
@property (nonatomic, strong) NSNumber *minBuy;

/**
 * 理财期限
 */
@property (nonatomic, strong) NSString *timeLimit;


/**
 * 取现到账
 */
@property (nonatomic, strong) NSString *cashTime;

/**
 * 购买须知
 */
@property (nonatomic, strong) NSString *notice;


/**
 * 产品详情
 */
@property (nonatomic, strong) NSString *info;


/**
 * 发布日期
 */
@property (nonatomic, strong) NSNumber *pubDate;


/**
 * 基金编码
 */
@property (nonatomic, strong) NSString *code;

 
@end
