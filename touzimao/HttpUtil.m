//
//  HttpUtil.m
//  bullfight
//
//  Created by goddie on 15/8/18.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "HttpUtil.h"
#import "AFNetworking.h"

@implementation HttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    // 1.获得请求管理者
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    // 2.发送GET请求
    [mgr setSecurityPolicy:policy];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObj) {
         if (success) {
             success(responseObj);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr setSecurityPolicy:policy];
//    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
//    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    // 2.发送POST请求
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObj) {
          if (success) {
              success(responseObj);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}
/**
 *  上传文件请求
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params dataSource:(FormData *)dataSource success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    
    // 1.获得请求管理者
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:dataSource.data name:dataSource.name fileName:dataSource.filename mimeType:dataSource.mimeType];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
/**
 *  用来封装文件数据的模型
 */
@implementation FormData



@end