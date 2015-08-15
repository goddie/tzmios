//
//  RegTwoController.h
//  touzimao
//
//  Created by goddie on 15/8/13.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegTwoController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txt1;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
- (IBAction)btnSendClick:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txt2;

@property (weak, nonatomic) IBOutlet UIButton *btnReg;

- (IBAction)btnRegClick:(id)sender;

@property (nonatomic, strong) NSString *phone;









@end
