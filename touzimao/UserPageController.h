//
//  UserPageController.h
//  touzimao
//
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPageController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtLv;
@property (weak, nonatomic) IBOutlet UILabel *txtChat;
@property (weak, nonatomic) IBOutlet UILabel *txtInvite;
@property (weak, nonatomic) IBOutlet UILabel *txtFollow;
@property (weak, nonatomic) IBOutlet UILabel *txtTotal;
@property (weak, nonatomic) IBOutlet UILabel *txtYesterday;
@property (weak, nonatomic) IBOutlet UIButton *btnInvite;
- (IBAction)btnInviteClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnChat;

- (IBAction)btnChatClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;

- (IBAction)btnFollowClick:(id)sender;


@property (nonatomic, strong) NSString *uuid;
@end
