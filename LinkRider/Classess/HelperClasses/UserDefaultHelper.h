//
//  UserDefaultHelper.h
//  Tinder
//
//  Created by Elluminati - macbook on 10/04/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USERDEFAULT [NSUserDefaults standardUserDefaults]

//UserDefault Keys
extern NSString *const UD_USER_INFO;//UserInfo

extern NSString *const UD_CURRENTLATITUDE;//currentLatitude
extern NSString *const UD_CURRENTLONGITUDE;//currentLongitude
extern NSString *const UD_DEVICETOKEN;//DeviceToken


@interface UserDefaultHelper : NSObject
{
    NSMutableDictionary *userInfo;
    
    NSString *currentLatitude;
    NSString *currentLongitude;

}
-(id)init;
+(UserDefaultHelper *)sharedObject;

//getter
-(NSMutableDictionary *)userInfo;
-(NSString *)currentLatitude;
-(NSString *)currentLongitude;


//setter
-(void)setUserInfo:(NSMutableDictionary *)newUserInfo;
-(void)setCurrentLatitude:(NSString *)newLat;
-(void)setCurrentLongitude:(NSString *)newLong;
-(void)setDeviceToken:(NSString *)newDeviceToken;

@end
