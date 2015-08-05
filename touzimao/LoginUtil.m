//
//  LoginUtil.m
//  touzimao
//
//  Created by goddie on 15/8/2.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "LoginUtil.h"
 

@implementation LoginUtil

+(NSString*)getLocalUser
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *username=[mySettingData objectForKey:@"User"];
    
    return  username;
}

+(NSString*)getLocalUUID
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *uuid=[mySettingData objectForKey:@"UUID"];
    
    return  uuid;
}

+(void)saveLocalUser:(User*)user
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    //NSString *username=[mySettingData objectForKey:@"User"];
    
    [mySettingData setObject:user.username forKey:@"User"];
}

+(void)saveLocalUUID:(User*)user
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    //NSString *username=[mySettingData objectForKey:@"User"];
    
    [mySettingData setObject:user.uuid forKey:@"UUID"];
    
}

+(void)clearLocal
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

@end
