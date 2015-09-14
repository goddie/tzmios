//
//  FundDetailController.m
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <AlipaySDK/AlipaySDK.h>

#import "FundDetailController.h"
#import "MyPageTableCell.h"
#import "FundDetailHeaderController.h"
#import "AccountController.h"
#import "AFNetworking.h"
#import "Product.h"
#import "BuyProductCell.h"
#import "BuyProductInputCell.h"
#import "LoginUtil.h"
#import "TradeRecord.h"
#import "WebPageController.h"

#import "DataSigner.h"
#import "Order.h"
#import "ConfigCell.h"
#import "UIViewController+Custome.h"
#import "AppDelegate.h"

@interface FundDetailController ()

@end

@implementation FundDetailController
{
    NSArray *buttons;
    FundDetailHeaderController *headerView;
    NSArray *cellTitles;
    
    TradeRecord *tradeRecord;
    
    Product *model;
    
    NSNumber *payType;
    
    NSDictionary *orderDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:@"paySuccess" object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //支付宝
    payType = [NSNumber numberWithInteger:1];
    
    buttons = [NSArray arrayWithObjects:@"购买须知",@"产品详情", nil];
    
    headerView = [[FundDetailHeaderController alloc] initWithNibName:@"FundDetailHeaderController" bundle:nil];
    [self addChildViewController:headerView];
    
    self.tableView.tableHeaderView = headerView.view;
    
    //self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, 546.0f);
    
    //NSLog(@"%f",self.tableView.tableHeaderView.frame.size.height);
    
    self.tableView.tableFooterView = [self addButton];
    
    cellTitles = @[@"同意购买",@"公开收益",@"同步买入",@"同步卖出",@"购买金额",@"支付方式"];
    
    tradeRecord = [TradeRecord new];
    
    if (self.uuid.length>0) {
        [self loadData];
    }
    
    if (self.fid == nil) {
        self.fid=@"";
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  支付成功
 *
 *  @param notice <#notice description#>
 */
-(void)paySuccess:(NSNotification*)notice
{
    NSString *result = (NSString*)notice.object;
    
}

/**
 *  立即购买按钮
 *
 *  @return <#return value description#>
 */
- (UIView*)addButton
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120.0f)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 302, 46)];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"redBtn.png"] forState:UIControlStateNormal];
    [btn setTitle:@"立即购买" forState:UIControlStateNormal];
    
    [view addSubview:btn];
    
    [btn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    return  view;
}

/**
 *  创建订单
 */
-(void)newOrder
{
    
    NSString *uid = [LoginUtil getLocalUUID];
    if (!uid) {
        [[AppDelegate delegate] loginPage];
        return;
    }
    
    NSString *total;
    BuyProductInputCell *cell = (BuyProductInputCell*)[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
    total = cell.txt1.text;
    
    if (total.length==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入购买金额" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alert show];
        
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"pid":self.uuid,
                                 @"uid":uid,
                                 @"name":model.CPMC,
                                 @"total":total,
                                 @"payType":payType
                                 };
    
    [self showHud];
    
    [self post:@"order/json/add" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            orderDict = [[dict objectForKey:@"data"] mutableCopy];
            [self addOrder];
        }
        [self hideHud];
    }];

}


-(void)newTradeRecord
{
    BuyProductInputCell *cell = (BuyProductInputCell*)[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
    tradeRecord.amount = [NSNumber numberWithFloat:[cell.txt1.text floatValue]];
    
    BuyProductCell *cell1 = (BuyProductCell*)[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (cell1.sw1.on) {
        tradeRecord.agreeBuy = [NSNumber numberWithInteger:1];
    }else
    {
        tradeRecord.agreeBuy = [NSNumber numberWithInteger:0];
    }
    
    BuyProductCell *cell2 = (BuyProductCell*)[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    if (cell2.sw1.on) {
        tradeRecord.isShow = [NSNumber numberWithInteger:1];
    }else
    {
        tradeRecord.isShow = [NSNumber numberWithInteger:0];
    }
    
    
    BuyProductCell *cell3 = (BuyProductCell*)[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    if (cell3.sw1.on) {
        tradeRecord.synBuy= [NSNumber numberWithInteger:1];
    }else
    {
        tradeRecord.synBuy = [NSNumber numberWithInteger:0];
    }
    
    
    BuyProductCell *cell4 = (BuyProductCell*)[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    if (cell4.sw1.on) {
        tradeRecord.synSell = [NSNumber numberWithInteger:1];
    }else
    {
        tradeRecord.synSell = [NSNumber numberWithInteger:0];
    }
    
    if (orderDict.count==0) {
        
        return;
    }

    NSDictionary *parameters = @{
                                 @"pid":self.uuid,
                                 @"uid":[LoginUtil getLocalUUID],
                                 @"fid":self.fid,
                                 @"amount":[tradeRecord.amount stringValue],
                                 @"optName":@"买进",
                                 @"agreeBuy":[tradeRecord.agreeBuy stringValue],
                                 @"isShow":[tradeRecord.isShow stringValue],
                                 @"synBuy":[tradeRecord.synBuy stringValue],
                                 @"synSell":[tradeRecord.synSell stringValue],
                                 @"type":@"1",
                                 @"tradeNo":[orderDict objectForKey:@"tradeNo"]
                                 };
    
    [self post:@"traderecord/json/add" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"购买成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            alert.tag =100;
            [alert show];
            
            //[self.navigationController popViewControllerAnimated:YES];
            
        }

    }];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  购买按钮
 */
-(void)buyClick
{
    
    [self newOrder];
    
    
}



-(void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"uuid":self.uuid
                                 };
    [manager POST:[GlobalUtil requestURL:@"product/json/detail"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
            NSDictionary *dc = [dict objectForKey:@"data"];
            
            
            model = [MTLJSONAdapter modelOfClass:[Product class] fromJSONDictionary:dc error:nil];
            
            if (model) {
                
                float per = [model.SYLZG floatValue] /100.0f;
                
                headerView.txtWeek.text = @"最高收益";
                
                headerView.txtPercent.text  = [NSString stringWithFormat:@"%.1f",per];
                
                headerView.txtMin.text = [model.TZMKED stringValue];
                
                NSString *r = @"低风险";
                
                if([model.FXDJ intValue]==2)
                {
                    r = @"高风险";
                }
                
                headerView.txtRisk.text = r;
                
                
            }
            
            
//            headerView.txtPercent.text  = [NSString stringWithFormat:@"%@",[model.weekRate stringValue]] ;
//            headerView.txtTenthou.text = [NSString stringWithFormat:@"%@",[model.tenThousand stringValue]];
//            headerView.txtPubdate.text =[NSString stringWithFormat:@"%@",[GlobalUtil getDateFromUNIX:model.pubDate]];
//            headerView.txtRisk.text = model.risk;
//            headerView.txtCycle.text= [NSString stringWithFormat:@"%@",[model.cycle stringValue]];
//            headerView.txtCash.text = model.cashTime;
            
 
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


-(void)addOrder
{
    
    if (orderDict.count==0) {
        return;
    }
    
    NSString *partner = @"2088711708694562";
    NSString *seller = @"2088711708694562";
    NSString *privateKey = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBANz6ZCx3qb+C6rxAC84N/Fdp9UzC2oHGv92gnr5GABGzIfqyRwlA1BqUfonul8J+FuaJDumz/CGw9yHEAyAtls6vROvvg2T/AIM4tARg8HMr3kfoXqp+TeQ6nUZ8oSiXiJUkv88BmizBKf3ruZ/cuc+Wdy4wLmr9yKh2FFOYTml3AgMBAAECgYAbGWXRgjdB8ichQOVxtotcmPTpHfg39AyxfDIbeXAmu4YOPXCytM2OGOnPtn/L7TSXvvUiOd1QsGgOLwCHILAenC2EMfwnjAeBYF8IK5R5e4E//3jt8z+Tlt7xetW2PmTQagMCYIlJPr/OboIaa6ecMUBjiRnKuqCKotdn5If/+QJBAP6EXxf55zyD4yCEqbPCQGBcNde/CNMcbWtAGANVo4JwbOZoieKxjfjr02uEIsfogefdwWC+DXdGCo9rCdDoNS0CQQDeQ/6KQFcuJa+88iXgic4Dg3zoXTSJKGQpdVCQMON1YhfonKH8W/c8aG3DfyJfYjzukqWvAKGtRC1acccGkQezAkBQC0to2/RISOYufOpuGUJry7Q3ROI+mqsi1sZ2jgFdbYQiNnBe9h5DUc9s+eKCYnIwfMJrbXoIr+N0VWKB6/WFAkA0aHnzZVppIi++8KXnvPabs3xXWerSUHjVobjeVvi7K+cRTSWQ2KqCTulayHZ1YTeW1XNFwXNd5I6BHgTc0oOrAkB0Yla4+VcQ5jUfPMaTmgMmX9xZOSZYsICDaT38BaR1bsbTTwE/3Uq3sOZg2t3pDiiVleG9IB1mmjddFewjoTuN";
    
    
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [orderDict objectForKey:@"tradeNo"]; //订单ID(由商家□自□行制定)
    order.productName = model.CPMC; //商品标题
    order.productDescription = model.CPMC; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",0.01f]; //商 品价格
    order.notifyURL = [baseURL stringByAppendingString:@"order/notice/alipay"]; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"touzicatios";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description]; NSLog(@"orderSpec = %@",orderSpec);
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


-(void)payType
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"关闭"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"支付宝支付", @"猫币账户",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ConfigCell *cell =  (ConfigCell*)[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:1]];
    
    //支付宝
    if (buttonIndex == 0) {
        
        cell.txtValue.text = [actionSheet buttonTitleAtIndex:buttonIndex];
        payType = [NSNumber numberWithInteger:1];
    }
    
    //猫币
    if (buttonIndex == 1) {
        
        cell.txtValue.text = [actionSheet buttonTitleAtIndex:buttonIndex];
        payType = [NSNumber numberWithInteger:2];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    
    if (section==1) {
        return cellTitles.count;
    }
    
    return buttons.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        //购买须知
        if (indexPath.row==0) {
            WebPageController *web = [[WebPageController alloc] initWithNibName:@"WebPageController" bundle:nil];
            web.title = @"购买须知";
            web.URL = [baseURL stringByAppendingFormat:@"productdetail/page/detail?pid=%@&type=1",self.uuid];
            [self.navigationController pushViewController:web animated:YES];
        }
        
        //产品详情
        if (indexPath.row==1) {
            WebPageController *web = [[WebPageController alloc] initWithNibName:@"WebPageController" bundle:nil];
            web.title = @"产品详情";
            web.URL = [baseURL stringByAppendingFormat:@"productetail/page/detail?pid=%@&type=2",self.uuid];
            
            [self.navigationController pushViewController:web animated:YES];
        }
    }
    
    if (indexPath.section==1) {
        if (indexPath.row ==5) {
            
            [self payType];
            
        }
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==1) {
        
        //输入金额
        if (indexPath.row==4) {
            static NSString *CellIdentifier = @"BuyProductInputCell";
            BuyProductInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell==nil){
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            return cell;

        }
        
        //支付方式
        if (indexPath.row==5) {
            static NSString *CellIdentifier = @"ConfigCell";
            ConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell==nil){
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.txtName.text = [cellTitles objectAtIndex:indexPath.row];
            cell.txtValue.text = @"支付宝支付";
            
            return cell;
        }
        
        static NSString *CellIdentifier = @"BuyProductCell";
        BuyProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.txt1.text = [cellTitles objectAtIndex:indexPath.row];
        
        return cell;
    }
    
    
    static NSString *CellIdentifier = @"MyPageTableCell";
    MyPageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.txt1.text = [buttons objectAtIndex:indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}



@end
