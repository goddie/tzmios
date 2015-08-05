//
//  WebPageController.h
//  touzimao
//
//  Created by goddie on 15/8/4.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebPageController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *web;

@property (nonatomic, strong) NSString *URL;


@end
