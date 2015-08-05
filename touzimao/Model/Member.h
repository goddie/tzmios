//
//  Member.h
//  touzimao
//
//  Created by goddie on 15/8/2.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Member : BaseModel
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;


@end
