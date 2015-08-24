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
 * 产品编号	BIGINT
 */

@property (nonatomic, strong) NSNumber *CPBH;

/**
 * 产品简称	VARCHAR(50)
 */

@property (nonatomic, strong) NSString *CPJC;

/**
 * 产品名称	VARCHAR(200)
 */

@property (nonatomic, strong) NSString *CPMC;

/**
 * 产品期限	INT
 */

@property (nonatomic, strong) NSNumber *CPQX;

/**
 * 产品系列	TINYINT
 */

@property (nonatomic, strong) NSNumber *CPXL;

/**
 * 发行费用最低	INT
 */

@property (nonatomic, strong) NSNumber *FXFYZD;

/**
 * 发行费用最高	INT
 */
@property (nonatomic, strong) NSNumber *FXFYZG;

/**
 * 发行费用说明	VARCHAR(500)
 */

@property (nonatomic, strong) NSString *FXFYSM;

/**
 * 收益率最低	INT
 */

@property (nonatomic, strong) NSNumber *SYLZD;

/**
 * 收益率最高	INT
 */
@property (nonatomic, strong) NSNumber *SYLZG;

/**
 * 收益率说明	VARCHAR(500)
 */

@property (nonatomic, strong) NSString *SYLSM;

/**
 * 收益类型	TINYINT
 */

@property (nonatomic, strong) NSNumber *SYLX;

/**
 * 收益类型说明	VARCHAR(100)
 */

@property (nonatomic, strong) NSString *SYLXSM;

/**
 * 付息方式	TINYINT
 */

@property (nonatomic, strong) NSNumber *FXFS;

/**
 * 投资领域	TINYINT
 */

@property (nonatomic, strong) NSNumber *TZLY;

/**
 * 所在区域	TINYINT
 */

@property (nonatomic, strong) NSNumber *SZQY;

/**
 * 大小配比	TINYINT
 */

@property (nonatomic, strong) NSNumber *DXPB;

/**
 * 大小配比说明	VARCHAR(100)
 */

@property (nonatomic, strong) NSString *DXPBSM;

/**
 * 质押物	VARCHAR(20)
 */

@property (nonatomic, strong) NSString *ZYW;

/**
 * 风险等级	TINYINT
 */

@property (nonatomic, strong) NSNumber *FXDJ;

/**
 * 发行机构	BIGINT
 */

@property (nonatomic, strong) NSNumber *FXJG;

/**
 * 规模	BIGINT
 */

@property (nonatomic, strong) NSNumber *GUIMO;

/**
 * 已进款金额	BIGINT
 */

@property (nonatomic, strong) NSNumber *YJKJE;

/**
 * 投资门槛额度	BIGINT
 */

@property (nonatomic, strong) NSNumber *TZMKED;

/**
 * 募集账号	VARCHAR(300)
 */

@property (nonatomic, strong) NSString *MJZH;

/**
 * 是否推荐	TINYINT
 */

@property (nonatomic, strong) NSNumber *SFTJ;

/**
 * 是否包销	TINYINT
 */

@property (nonatomic, strong) NSNumber *SFBX;

/**
 * 推荐星级	INT
 */

@property (nonatomic, strong) NSNumber *TJXJ;

/**
 * 结款时点	TINYINT
 */

@property (nonatomic, strong) NSNumber *JKSD;

/**
 * 结款时点说明	VARCHAR(100)
 */

@property (nonatomic, strong) NSString *JKSDSM;

/**
 * 起息日	CHAR(10)
 */

@property (nonatomic, strong) NSString *QXRQ;

/**
 * 到期日	CHAR(10)
 */

@property (nonatomic, strong) NSString *DQRQ;


/**
 * 产品文档url	VARCHAR(500)
 */

@property (nonatomic, strong) NSString *CPWDURL;

/**
 * 产品状态	TINYINT
 */

@property (nonatomic, strong) NSNumber *CPZT;

/**
 * 是否有效	TINYINT
 */

@property (nonatomic, strong) NSNumber *SFYX;

/**
 * 产品经理	BIGINT
 */

@property (nonatomic, strong) NSNumber *CPJL;

/**
 * 产品经理姓名	VARCHAR(50)
 */

@property (nonatomic, strong) NSString *CPJLXM;

@property (nonatomic, strong) NSArray *list;

@end
