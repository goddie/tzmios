//
//  UserInfo.h
//  touzimao
//
//  Created by goddie on 15/9/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserInfo : UITableViewController<UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) User *user;
@end
