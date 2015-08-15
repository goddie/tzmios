//
//  GlobalUtil.h
//  Bullfight
//
//  Created by goddie on 15/6/14.
//  Copyright (c) 2015年 goddie. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface GlobalUtil: NSObject

/**
 *  字符串转UIColor
 *
 *  @param rgb <#rgb description#>
 *
 *  @return <#return value description#>
 */
+ (UIColor*) colorWithArray:(NSString*)rgb;

/**
 *  设置UIView使用9宫格图片
 *
 *  @param view      <#view description#>
 *  @param imageName <#imageName description#>
 *  @param top       <#top description#>
 *  @param right     <#right description#>
 */
+ (void)set9PathImage:(UIView*)view imageName:(NSString*)imageName top:(CGFloat)top right:(CGFloat)right;

/**
 *  按钮北京颜色和颜色
 *
 *  @param button <#button description#>
 *  @param color  <#color description#>
 */
+ (void)setButtonColor:(UIButton*)button color:(NSString*)color;

/**
 *  设置navigator按钮
 *
 *  @param imageName <#imageName description#>
 *  @param target    <#target description#>
 *  @param action    <#action description#>
 *
 *  @return <#return value description#>
 */
+ (UIBarButtonItem*)getBarButton:(NSString*)imageName target:(id)target action:(SEL)action;

/**
 *  遮罩图片
 *
 *  @param image <#image description#>
 *  @param mask  <#mask description#>
 *
 *  @return <#return value description#>
 */
+(UIImage*)getMaskImage:(NSString*)imageName mask:(NSString*)maskName;


/**
 *  遮罩图片
 *
 *  @param image     <#image description#>
 *  @param maskImage <#maskImage description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage*)getMaskImage:(UIImage *)image withMask:(UIImage *)maskImage;
/**
 *  图片大小
 *
 *  @param image   <#image description#>
 *  @param newSize <#newSize description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *) resizeImage:(UIImage *)image size:(CGSize)newSize;


/**
 *  给制定view添加点击事件
 *
 *  @param view  <#view description#>
 *  @param touch <#touch description#>
 */
+(void) addTouchToView:(id)target sender:(id)sender action:(SEL)action;


/**
 *  给view上面添加一个按钮
 *
 *  @param target    <#target description#>
 *  @param touchView <#touchView description#>
 *  @param action    <#action description#>
 */
+(void) addButtonToView:(id)target sender:(UIView*)touchView action:(SEL)action data:(NSInteger)data;


+(void) addButton:(id)target sender:(UIView*)touchView action:(SEL)action data:(NSObject*)data;


/**
 *  设置默认背景颜色
 *
 *  @param view <#view description#>
 */
+(void) initDefaultBgColor:(UIView*)view;


/**
 *  请求URL
 *
 *  @param ext <#ext description#>
 */
+(NSString*) requestURL:(NSString*)ext;

/**
 *  unix时间转date
 *
 *  @param date <#date description#>
 *
 *  @return <#return value description#>
 */
+(NSString*) getDateFromUNIX:(NSNumber*)date;


@end