//
//  GlobalUtil.m
//  Bullfight
//
//  Created by goddie on 15/6/14.
//  Copyright (c) 2015年 goddie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalUtil.h"
#import "AppDelegate.h"
#import "MyButton.h"

@implementation GlobalUtil: NSObject

+ (UIColor*) colorWithArray:(NSString*)rgb
{
    NSArray* arr = [rgb componentsSeparatedByString: @","];
    
    UIColor* color = [UIColor colorWithRed:  [[arr objectAtIndex:0] floatValue]/255.0 green:[[arr objectAtIndex:1] floatValue]/255.0 blue:[[arr objectAtIndex:2] floatValue]/255.0 alpha:1];
    
    return color;
}


+ (void)set9PathImage:(UIView *)view imageName:(NSString*)imageName top:(CGFloat)top right:(CGFloat)right
{
    UIImage* image = [UIImage imageNamed:imageName];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(top, right, top, right);
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    [view setBackgroundColor:[UIColor clearColor]];
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    
    [view addSubview:imageView];
    
    
}

+ (void)set9PathImage:(UIView *)view imageName:(NSString*)imageName insets:(UIEdgeInsets)insets
{
    UIImage* image = [UIImage imageNamed:imageName];
    
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    [view setBackgroundColor:[UIColor clearColor]];
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
//    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    
//    NSLayoutConstraint *c1 = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
//    NSLayoutConstraint *c2 = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
//    NSLayoutConstraint *c3 = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0];
//    NSLayoutConstraint *c4 = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0];
//    
//    [imageView addConstraints:@[c1,c2,c3,c4]];
    
    imageView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    
    [view addSubview:imageView];
}


+ (void)setButtonColor:(UIButton*)button color:(NSString*)color
{
    UIColor* newColor= [self colorWithArray:color];
    
    [button setTitleColor:newColor forState:UIControlStateNormal];
}

+ (UIBarButtonItem*)getBarButton:(NSString*)imageName target:(id)target action:(SEL)action
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[back setTitle:@"已改" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 32, 32)];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //[back setBackgroundColor:[UIColor redColor]];
    
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    barButton.target = target;
    return barButton;
}


+(UIImage*)getMaskImage:(NSString*)imageName mask:(NSString*)maskName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *maskImage = [UIImage imageNamed:maskName];
    
    return [self getMaskImage:image withMask:maskImage];
}


+ (UIImage*)getMaskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    if (CGImageGetAlphaInfo([image CGImage]) == kCGImageAlphaNone)
    {
        NSLog(@"image no alpha");
    }
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    return [UIImage imageWithCGImage:masked];

}


// resize the original image and return a new UIImage object
+ (UIImage *) resizeImage:(UIImage *)image size:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//-(CGImageRef) CopyImageAndAddAlphaChannel :(CGImageRef) sourceImage
//{
//    CGImageRef retVal = NULL;
//    size_t width = CGImageGetWidth(sourceImage);
//    size_t height = CGImageGetHeight(sourceImage);
//    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    
//    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,
//                                                          8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
//    
//    if (offscreenContext != NULL) {
//        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
//        
//        retVal = CGBitmapContextCreateImage(offscreenContext);
//        CGContextRelease(offscreenContext);
//    }
//    
//    CGColorSpaceRelease(colorSpace);
//    return retVal;
//}

+(void) addTouchToView:(id)target sender:(id)sender action:(SEL)action
{
    UITapGestureRecognizer *tapGestureRecognizer =  [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [sender addGestureRecognizer:tapGestureRecognizer];
}


+(void) addButtonToView:(id)target sender:(UIView*)touchView action:(SEL)action data:(NSObject*)data;
{
    MyButton *btn = [[MyButton alloc] initWithFrame:CGRectMake(0, 0, touchView.frame.size.width, touchView.frame.size.height)];
    [touchView addSubview:btn];
    touchView.userInteractionEnabled=YES;
    //btn.backgroundColor = [UIColor yellowColor];
    
    [btn setData:data];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"" forState:UIControlStateNormal];
//    [btn setTag:data];
}


+(void) initDefaultBgColor:(UIView*)view
{
    [view setBackgroundColor:[UIColor whiteColor]];
    
}


+(NSString*) requestURL:(NSString*)ext
{
    return [baseURL stringByAppendingString:ext];
}


+(NSString*) getDateFromUNIX:(NSNumber*)date
{
//    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
//    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:d];
//    int weekday = [weekdayComponents weekday];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *stringFromDate = [formatter stringFromDate:d];
    
    return stringFromDate;
    
}


+(void) setMaskImageQuick:(UIView*)viewToMask withMask:(NSString*)maskImageName point:(CGPoint)size
{
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[[UIImage imageNamed:maskImageName] CGImage];
    mask.frame = CGRectMake((viewToMask.frame.size.width -size.x )*0.5f , 0, size.x, size.y);
    
    viewToMask.layer.mask = mask;
    viewToMask.layer.masksToBounds = YES;
}



/**
 *  pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
 *
 *  @param color <#color description#>
 *
 *  @return <#return value description#>
 */
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


+(NSString*)toString:(id)value
{
    if ([value isKindOfClass:[NSNumber class]]) {
        
        if (value==nil) {
            return @"";
        }
        
        NSNumber *num = (NSNumber*)value;
        
        NSInteger i = [num intValue];
        
        return [NSString stringWithFormat:@"%ld",i];
        
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        
        if (value==nil) {
            return @"";
        }
        
        return (NSString*)value;
        
    }
    return @"";
}


+(void)saveLocal:(NSString*)key value:(NSObject*)value
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    //    NSMutableArray *arr = [mySettingData objectForKey:key];
    
    [mySettingData setObject:value forKey:key];
    
    [mySettingData synchronize];
    
}

+(NSObject*)getLocal:(NSString*)key
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSObject *data = [mySettingData objectForKey:key];
    return  data;
}


@end