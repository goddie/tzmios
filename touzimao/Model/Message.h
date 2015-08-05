//
//  Message.h
//  touzimao
//
//  Created by goddie on 15/8/4.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface Message : BaseModel

@property (nonatomic, strong) NSString *uuid;

@property (nonatomic, strong) NSString *from;

@property (nonatomic, strong) NSString *sendTo;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSNumber *createdDate;

@end
