//
//  UserDefaultHelper.m
//  Tinder
//
//  Created by Elluminati - macbook on 10/04/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//


#import "UserDefaultHelper.h"

//UserDefault Keys
NSString *const UD_USER_INFO=@"UserInfo";

NSString *const UD_CURRENTLATITUDE=@"currentLatitude";
NSString *const UD_CURRENTLONGITUDE=@"currentLongitude";
NSString *const UD_DEVICETOKEN=@"DeviceToken";

@implementation UserDefaultHelper

#pragma mark -
#pragma mark - Init

-(id)init
{
    if((self = [super init]))
    {
        [self setAllData];
    }
    return self;
}

+(UserDefaultHelper *)sharedObject
{
    static UserDefaultHelper *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[UserDefaultHelper alloc] init];
    });
    return obj;
}

#pragma mark -
#pragma mark - SetAllData

-(void)setAllData
{
    [self currentLatitude];
    [self currentLongitude];
    [self deviceToken];
}

#pragma mark -
#pragma mark - Getter

-(NSMutableDictionary *)userInfo{
    userInfo=[USERDEFAULT objectForKey:UD_USER_INFO];
    return userInfo;
}
-(NSString *)currentLatitude
{
    currentLatitude=[USERDEFAULT objectForKey:UD_CURRENTLATITUDE];
    if (currentLatitude==nil) {
        currentLatitude=@"0.000000";
    }
    return currentLatitude;
}
-(NSString *)currentLongitude
{
    currentLongitude=[USERDEFAULT objectForKey:UD_CURRENTLONGITUDE];
    if (currentLongitude==nil) {
        currentLongitude=@"0.000000";
    }
    return currentLongitude;
}
-(NSString *)deviceToken
{
//    deviceTokenString=[USERDEFAULT objectForKey:UD_DEVICETOKEN];
//    if (deviceTokenString==nil) {
//        deviceTokenString=@"IOS_SIMULATOR";
//    }
    return deviceTokenString;
}

#pragma mark -
#pragma mark - Setter

-(void)setUserInfo:(NSMutableDictionary *)newUserInfo
{
    userInfo=newUserInfo;
    [USERDEFAULT setObject:userInfo forKey:UD_USER_INFO];
    [USERDEFAULT synchronize];
}
-(void)setCurrentLatitude:(NSString *)newLat
{
    currentLatitude=newLat;
    [USERDEFAULT setObject:currentLatitude forKey:UD_CURRENTLATITUDE];
    [USERDEFAULT synchronize];
}
-(void)setCurrentLongitude:(NSString *)newLong
{
    currentLongitude=newLong;
    [USERDEFAULT setObject:currentLongitude forKey:UD_CURRENTLONGITUDE];
    [USERDEFAULT synchronize];
}
-(void)setDeviceToken:(NSString *)newDeviceToken
{
//    deviceTokenString=newDeviceToken;
    [USERDEFAULT setObject:deviceTokenString forKey:UD_DEVICETOKEN];
    [USERDEFAULT synchronize];
}

@end
