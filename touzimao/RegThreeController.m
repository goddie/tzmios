//
//  RegTwoController.m
//  touzimao
//
//  Created by goddie on 15/8/13.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "RegThreeController.h"

#import "AFNetworking.h"
#import "MTLJSONAdapter.h"
#import "User.h"
#import "LoginUtil.h"
#import "AppDelegate.h"
#import "UserInfo.h"
#import "WXApi.h"

#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface RegThreeController ()

@end

@implementation RegThreeController
{
    NSString *head;
    NSString *nickname;
    MBProgressHUD *hudView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxauth:) name:@"wxauth" object:nil];
    
    self.title = @"完善个人资料";
 
 
    
    hudView = [[MBProgressHUD alloc] initWithView:self.view];
    
//    [hudView setLabelText:@"Loading"];
    [hudView setMode:MBProgressHUDModeIndeterminate];
    [hudView setRemoveFromSuperViewOnHide:YES];


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

- (IBAction)btnSendClick:(id)sender {



    
}


-(void)wxauth:(NSNotification*)notice
{
    [hudView show:YES];
    [hudView hide:YES afterDelay:20.0];
    
    NSDictionary *dict = (NSDictionary*)notice.object;
    NSString *openid = [dict objectForKey:@"openid"];
    NSString *token = [dict objectForKey:@"access_token"];
    
    NSString *url = [ NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openid ];
    
    NSURL * URL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:URL];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"error: %@",[error localizedDescription]);
    }else{
 
        NSLog(@"backData : %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        if (![dict objectForKey:@"errcode"]) {
            [self updateInfo:dict];
        }

    }

    
}

/**
 *  用户头像，最后一个数值代表正方形头像大小（有0、46、64、96、132数值可选，0代表640*640正方形头像），用户没有头像时该项为空
 *
 *  @param dict <#dict description#>
 */
-(void)updateInfo:(NSDictionary*)dict
{
    nickname = [dict objectForKey:@"nickname"];
    head = [dict objectForKey:@"headimgurl"];
    
    if (head) {
        [self downloadImageInBackground:head];
    }
    
}


/**
 *  更新昵称
 */
-(void)updateNickname
{
    NSString *uid = [LoginUtil getLocalUUID];
    NSDictionary *parameters = @{
                                 @"uid": uid,
                                 @"nickname": nickname,
                                 };
    [self post:@"user/json/updatenickname" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {

            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"授权成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            [self finish];
        }
        
    
    }];
}

/**
 *  下载并上传头像
 *
 *  @param photourl <#photourl description#>
 */
- (void)downloadImageInBackground:(NSString *)photourl
{
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:photourl]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [self saveImage:responseObject];
//        NSString *documentsDirectory = nil;
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        documentsDirectory = [paths objectAtIndex:0];
//        NSString *pathString = [NSString stringWithFormat:@"%@/%@",documentsDirectory, guideName];
//        
//        // Save Image
//        NSData *imageData = UIImageJPEGRepresentation(image, 90);
//        [imageData writeToFile:pathString atomically:YES];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
 
}


/**
 *  保存头像
 *
 *  @param image <#image description#>
 */
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
    
    NSString *uid = [LoginUtil getLocalUUID];
    
    if(!uid)
    {
        return;
    }
    
    
 
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"uid": uid
                                 };
    
    [manager POST:[baseURL stringByAppendingString:@"user/json/upavatar"] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(selfPhoto)
                                    name:@"file"
                                fileName:@"avatar.png"
                                mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            [self updateNickname];
        }
        
        
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



- (IBAction)btn1Click:(id)sender {

    SendAuthReq* req =  [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo"; // @"post_timeline,sns"
    req.state = @"123";
    
    [WXApi sendReq:req];

}


- (IBAction)btn2Click:(id)sender {
    
    [self finish];
}

-(void)finish
{
    
    [hudView hide:YES];

    
    [[AppDelegate delegate] changeRoot];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
@end
