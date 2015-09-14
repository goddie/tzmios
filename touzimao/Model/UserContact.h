//
//  UserContact.h
//  touzimao
//
//  Created by goddie on 15/9/13.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface UserContact : BaseModel


@property (nonatomic, strong) NSString *uuid;
/**
 * 用户
 */
@property (nonatomic, strong) NSDictionary *user;

/**
 * 姓名
 */
@property (nonatomic, strong) NSString *name;

/**
 * 电话
 */
@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *phone2;

@property (nonatomic, strong) NSString *phone3;
/**
 * 联系人
 */
@property (nonatomic, strong) NSDictionary *contact;

/**
 * 小猫推荐
 */
@property (nonatomic, strong) NSNumber *isRecommend;


/**
 * 粉丝
 */
@property (nonatomic, strong) NSNumber *isFan;


/**
 * 关注他
 */
@property (nonatomic, strong) NSNumber *isFollow;


@end
