//
//  AccountController.m
//  touzimao
//  账户管理
//  Created by goddie on 15/7/5.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>
#import "AccountController.h"
#import "UserHeaderCell.h"
#import "ConfigCell.h"
#import "BtnCell.h"
#import "LoginUtil.h"
#import "LoginController.h"
#import "AFNetworking.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "UpPassword.h"
#import "UserInfo.h"

@interface AccountController ()

@end

@implementation AccountController
{
    NSArray *buttons;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title =@"账户管理";
    
    buttons = [NSArray arrayWithObjects:@"头像管理",@"修改密码", nil];
    
    [self bindUser];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView setTableFooterView:v];
    //[self setExtraCellLineHidden:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadData];
}


-(void)bindUser
{
    if (self.user.avatar) {
        
        for (UITableViewCell *cell in self.tableView.visibleCells) {
            
            if ([cell isKindOfClass:[UserHeaderCell class]]) {
                UserHeaderCell *c = (UserHeaderCell*)cell;
                 NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:self.user.avatar]];
                [c.img sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"avatar.png"]];
            }
        }
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (actionSheet.tag == 200)
    {
        //NSLog(@"buttonIndex = [%d]",buttonIndex);
        switch (buttonIndex) {
            case 0://照相机
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                //			[self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
                
            case 1://本地相簿
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //			[self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
        
        
    }
    
    
    
    
}



#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    
    if ([mediaType isEqualToString:( NSString *)kUTTypeMovie]) {
        //        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        //        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    }
    
    //	[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //	[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}




- (void)saveImage:(UIImage *)image {
    //	NSLog(@"保存头像！");
    //	[userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.png"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    
    //UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(200.0f, 200.0f)];//将图片尺寸改为80*80
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(300, 300)];
    
    [UIImagePNGRepresentation(smallImage) writeToFile:imageFilePath atomically:YES];
    
//    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    //	[userPhotoButton setImage:selfPhoto forState:UIControlStateNormal];
    //    self.img1.image = selfPhoto;
    
    
    if(!self.user.uuid)
    {
        return;
    }
    
    [self showHud];
    
    __weak AccountController *wkSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"uid": self.user.uuid
                                 };
    
    [manager POST:[baseURL stringByAppendingString:@"user/json/upavatar"] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(selfPhoto)
                                    name:@"file"
                                fileName:@"avatar.png"
                                mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSDictionary *data = [dict objectForKey:@"data"];
            User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:nil];
            if (model) {
                
                self.user = model;
                [self.tableView reloadData];
            
            }
            
            
        }
        
        
        
        
        [wkSelf hideHud];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==100) {
        if (buttonIndex==1) {
            [self logout];
        }
    }
}

-(void)logout
{
    [LoginUtil clearLocal];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [[AppDelegate delegate] loginPage];
    
    
}

-(void)openPassword
{
    if (!self.user) {
        return;
    }
    
    
//    NSDictionary *parameters = @{
//                                 @"uid":self.user.uuid
//                                 };
    
    UpPassword *c1 =[[UpPassword alloc] initWithNibName:@"UpPassword" bundle:nil];
    [self.navigationController pushViewController:c1 animated:YES];
    
//    
//    [self showHud];
//    
//    [self post:@"user/json/uppasswordsms" params:parameters success:^(id responseObj) {
//        NSDictionary *dict = (NSDictionary *)responseObj;
//        
//        if ([[dict objectForKey:@"code"] intValue]==1) {
//            
//            
//            UpPassword *c1 =[[UpPassword alloc] initWithNibName:@"UpPassword" bundle:nil];
//            [self.navigationController pushViewController:c1 animated:YES];
//            
//            
//        }
//        
//        [self showHud];
//    }];
    

}


-(void)loadData
{
    
    NSString *uid = [self checkLogin];
    
    
    NSDictionary *parameters = @{
                                 @"uid":uid
                                 };
    
    
    [self post:@"user/json/detail" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
            NSDictionary *dc = [dict objectForKey:@"data"];
            
            
            
            self.user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dc error:nil];
            
            if (self.user) {
                
                [self.tableView reloadData];
            }
            
            
        }
    }];
    
}



#pragma mark - Table view data source


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        return buttons.count;
    }
    
    if (section==1) {
        return  1.0f;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    static NSString *CellIdentifier = @"FundListCell";
    //    FundListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if(cell==nil){
    //
    //        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
    //        cell = [nib objectAtIndex:0];
    //    }
    //    return cell;
    if (indexPath.section==0) {
        
        if (indexPath.row ==0 ) {
            static NSString *CellIdentifier = @"UserHeaderCell";
            UserHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell==nil){
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            //cell.txt.text = @"修改头像";
            
            if (self.user.avatar) {
                NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:self.user.avatar]];
                [cell.img sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"avatar.png"]];
            }
 
            cell.txt.text = self.user.nickname;
            cell.txt2.text = self.user.phone;
            
            return cell;
        }
        
        
        static NSString *CellIdentifier = @"ConfigCell";
        ConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.txtName.text = [buttons objectAtIndex:indexPath.row];
        
        
        return cell;
        
    }
    
    if (indexPath.section==1) {
        
        static NSString *CellIdentifier = @"ConfigCell";
        ConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        

        
        cell.txtName.text = @"退出登录";
        
        return cell;
        
    }
    

    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
        
//    BtnCell *cell = (BtnCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section==0) {
        //改头像
        if (indexPath.row == 0) {
            UserInfo *c1 = [[UserInfo alloc] initWithNibName:@"UserInfo" bundle:nil];
            c1.user = self.user;
            [self.navigationController pushViewController:c1 animated:YES];
        }
        
//        //微信认证
//        if (indexPath.row == 1) {
//            
//            //构造SendAuthReq结构体
//            SendAuthReq* req = [[SendAuthReq alloc] init];
//            req.scope = @"snsapi_userinfo" ;
//            req.state = @"123" ;
//            //第三方向微信终端发送一个SendAuthReq消息结构
//            [WXApi sendReq:req];
//            
//            
//        }
        
        if (indexPath.row == 1) {
    
            [self openPassword];
 
        }
    }
    

    
    
    if (indexPath.section==1) {
        if (indexPath.row == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出吗?" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"确定", nil];
            alert.tag =100;
            [alert show];
            

            

//            LoginController *c1 = [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
//            
//            [self presentViewController:c1 animated:YES completion:^{
//                
//            }];
            
//            self.navigationController.viewControllers  = @[c1];
            
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        


    }
    
 
    
}


@end
