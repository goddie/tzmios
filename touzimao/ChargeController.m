//
//  ChargeController.m
//  touzimao
//
//  Created by goddie on 15/9/13.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "ChargeController.h"
#import "DataSigner.h"
#import "Order.h"
#import "UIViewController+Custome.h"
#import <AlipaySDK/AlipaySDK.h>

@interface ChargeController ()

@end

@implementation ChargeController
{
    NSString *uid;
    NSString *tradeNO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    uid = [self checkLogin];
    self.title = @"猫猫宝充值";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *uidStr = [uid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    tradeNO = [NSString stringWithFormat:@"charge%@",[currentDateStr stringByAppendingString:uidStr]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addOrder
{

 
    
    
    
    NSString *partner = @"2088711708694562";
    NSString *seller = @"2088711708694562";
    NSString *privateKey = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBANz6ZCx3qb+C6rxAC84N/Fdp9UzC2oHGv92gnr5GABGzIfqyRwlA1BqUfonul8J+FuaJDumz/CGw9yHEAyAtls6vROvvg2T/AIM4tARg8HMr3kfoXqp+TeQ6nUZ8oSiXiJUkv88BmizBKf3ruZ/cuc+Wdy4wLmr9yKh2FFOYTml3AgMBAAECgYAbGWXRgjdB8ichQOVxtotcmPTpHfg39AyxfDIbeXAmu4YOPXCytM2OGOnPtn/L7TSXvvUiOd1QsGgOLwCHILAenC2EMfwnjAeBYF8IK5R5e4E//3jt8z+Tlt7xetW2PmTQagMCYIlJPr/OboIaa6ecMUBjiRnKuqCKotdn5If/+QJBAP6EXxf55zyD4yCEqbPCQGBcNde/CNMcbWtAGANVo4JwbOZoieKxjfjr02uEIsfogefdwWC+DXdGCo9rCdDoNS0CQQDeQ/6KQFcuJa+88iXgic4Dg3zoXTSJKGQpdVCQMON1YhfonKH8W/c8aG3DfyJfYjzukqWvAKGtRC1acccGkQezAkBQC0to2/RISOYufOpuGUJry7Q3ROI+mqsi1sZ2jgFdbYQiNnBe9h5DUc9s+eKCYnIwfMJrbXoIr+N0VWKB6/WFAkA0aHnzZVppIi++8KXnvPabs3xXWerSUHjVobjeVvi7K+cRTSWQ2KqCTulayHZ1YTeW1XNFwXNd5I6BHgTc0oOrAkB0Yla4+VcQ5jUfPMaTmgMmX9xZOSZYsICDaT38BaR1bsbTTwE/3Uq3sOZg2t3pDiiVleG9IB1mmjddFewjoTuN";
    
    
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = tradeNO; //订单ID(由商家□自□行制定)
    order.productName = @"猫猫宝充值"; //商品标题
    order.productDescription = @"猫猫宝充值"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",0.01f]; //商 品价格
    order.notifyURL = [baseURL stringByAppendingString:@"order/notice/charge"]; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"touzicatios";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //【callback 处理支付结果】
            NSLog(@"reslut = %@",resultDic);
            
            
            if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000) {
                
                [self newTradeRecord];
                
            }
            
        }];
    }
}



-(void)newTradeRecord
{

    
    NSDictionary *parameters = @{
                                 @"uid":uid,
                                 @"amount":self.txt1.text,
                                 @"tradeNo":tradeNO
                                 };
    
    [self post:@"traderecord/json/addcharge" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"充值成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alert.tag =100;
            [alert show];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
}


- (IBAction)btn1Click:(id)sender {
    if(!self.txt1.text)
    {
        return;
    }
    [self addOrder];
}
@end
