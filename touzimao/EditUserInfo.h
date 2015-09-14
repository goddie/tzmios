//
//  EditUserInfo.h
//  touzimao
//
//  Created by goddie on 15/9/12.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditUserInfo : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *txt1;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
- (IBAction)btn1Click:(id)sender;


/**
 *  昵称
 */
@property (nonatomic, strong) NSString *nickname;

/**
 *  简介
 */
@property (nonatomic, strong) NSString *info;


@property (nonatomic, strong) NSString *toEdit;

@end
