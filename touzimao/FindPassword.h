//
//  FindPassword.h
//  touzimao
//
//  Created by goddie on 15/9/12.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPassword : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txt1;
@property (weak, nonatomic) IBOutlet UITextField *txt2;
@property (weak, nonatomic) IBOutlet UITextField *txt3;
@property (weak, nonatomic) IBOutlet UITextField *txt4;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
- (IBAction)btn2Click:(id)sender;
- (IBAction)btn1Click:(id)sender;

@end
