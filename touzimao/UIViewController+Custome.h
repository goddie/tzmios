//
//  UIViewController+Custome.h
//  bullfight
//
//  Created by goddie on 15/8/18.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginUtil.h"
#import "MBProgressHUD.h"

@interface UIViewController (Custome)

- (void)globalConfig;

- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success;



@end
