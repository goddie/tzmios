//
//  WebPageController.m
//  touzimao
//
//  Created by goddie on 15/8/4.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "WebPageController.h"

@interface WebPageController ()

@end

@implementation WebPageController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.URL.length>0) {
        [self loadWebPageWithString];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadWebPageWithString
{
//    NSString *str = [baseURL stringByAppendingString:@"article/page/detail?title=关于来斗牛"];
    NSString* string2 = [self.URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:string2]];
    [self.web loadRequest:request];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}

@end
