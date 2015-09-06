//
//  User.h
//  touzimao
//
//  Created by goddie on 15/8/2.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface User : BaseModel


@property (nonatomic, strong) NSString *uuid;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *regIp;

/**
 *  昵称
 */
@property (nonatomic, strong) NSString *nickname;

/**
 * 等级
 */
@property (nonatomic, strong) NSNumber *level;

/**
 * 总财产
 */
@property (nonatomic, strong) NSNumber *wealth;

/**
 * 累计收益率
 */
@property (nonatomic, strong) NSNumber *totalRate;

/**
 * 年收益率
 */
@property (nonatomic, strong) NSNumber *yearRate;


/**
 * 跟买人数
 */
@property (nonatomic, strong) NSNumber *followBuy;

/**
 * 头像
 */
@property (nonatomic, strong) NSString *avatar;


/**
 * 个人介绍
 */
@property (nonatomic, strong) NSString *info;

/**
 * 手机
 */
@property (nonatomic, strong) NSString *phone;


/**
 * 微信账号
 */
@property (nonatomic, strong) NSString *weichat;


/**
 * 微博账号
 */
@property (nonatomic, strong) NSString *weibo;

/**
 *  总收益
 */
@property (nonatomic, strong) NSNumber *totalIncome;

/**
 *  昨日收益
 */
@property (nonatomic, strong) NSNumber *lastIncome;

/**
 *  猫币
 */
@property (nonatomic, strong) NSNumber *catCoin;

/**
 *  积分
 */
@property (nonatomic, strong) NSNumber *score;
@end
