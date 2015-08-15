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
    
    [mySettingData synchronize];
}

+(void)saveLocalUUID:(User*)user
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    //NSString *username=[mySettingData objectForKey:@"User"];
    
    [mySettingData setObject:user.uuid forKey:@"UUID"];
    
    [mySettingData synchronize];
    
}

+(void)clearLocal
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

+(void)addFollowData:(NSString*)uuid
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSArray *a = (NSArray*)[mySettingData objectForKey:@"Follow"];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:a];

    
    if (![arr containsObject:uuid]) {
        [arr addObject:uuid];
    }
    
    [mySettingData setObject:arr forKey:@"Follow"];
    
}

+(BOOL)hasFollow:(NSString*)uuid
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [mySettingData objectForKey:@"Follow"];
    
    if ([arr containsObject:uuid]) {
        return YES;
    }
    
    
    return NO;
}

@end
