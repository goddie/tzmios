//
//  EditUserInfo.m
//  touzimao
//
//  Created by goddie on 15/9/12.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "EditUserInfo.h"
#import "UIViewController+Custome.h"

@interface EditUserInfo ()

@end

@implementation EditUserInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self.toEdit isEqualToString:@"nickname"]) {
        self.txt1.text  = self.nickname;
    }
    
    if ([self.toEdit isEqualToString:@"info"]) {
        self.txt1.text  = self.info;
    }
    
    [self.txt1 becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn1Click:(id)sender {
    
    if (!self.txt1.text) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:10];
    
    NSString *uid = [self checkLogin];
    
    [parameters setObject:uid forKey:@"uid"];
    
    if ([self.toEdit isEqualToString:@"nickname"]) {
        [parameters setObject:self.txt1.text forKey:@"nickname"];
    }
    
    if ([self.toEdit isEqualToString:@"info"]) {
        [parameters setObject:self.txt1.text forKey:@"info"];

    }
    
    
    [self post:@"user/json/upuserinfo" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
        
    }];

}


@end
