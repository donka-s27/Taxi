//
//  AllConstants.h
//  Tinder
//
//  Created by Elluminati - macbook on 08/04/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//



//Api Url
//#define API_URL    @""//Local
#define API_URL    @"http://www.cityhire.net/admin/ws/"//Development
//#define API_URL    @""//Live



#define USER_TYPE   @"1"




typedef enum : NSUInteger{
    GenderMale=0,
    GenderFemale=1
}Gender;

typedef enum : NSUInteger{
    DriverStatAvailable=0,
    DriverStatNotAvailable=1
}DriverStat;

typedef enum : NSUInteger{
    PushDriverIdAssignRequest=1,
    PushDriverIdDeleteAssignment=2
}PushDriverID;



#define APPDELEGATE (AppDelegate*)[[UIApplication sharedApplication] delegate]


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//iOS7 Or less
#define ISIOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
//iPad/iPhone
#define IS_iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_iPhone ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)


//Colors
#define COLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


//iPhone5 helper
#define IS_iPhone5 ([UIScreen mainScreen].bounds.size.height == 568.0)
#define ASSET_BY_SCREEN_HEIGHT(regular) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : [regular stringByAppendingString:@"-568h"])

#define SET_XIB(regular) (isiPhone ? regular : [regular stringByAppendingString:@"_iPad"])


#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif


//////////Macro Helper///////////
#define COLOR_BACKGROUND [UIColor colorWithRed:(230.0/255) green:(224.0/255) blue:(202.0/255) alpha:1.0]
#define DATE_FORMATE_DOB        @"yyyy-MM-dd"

//Webservice fix response
#define WS_UBER_ALPHA           @"uber_alpha"
#define WS_STATUS               @"status"
#define WS_MESSAGE              @"message"
#define WS_STATUS_SUCCESS       @"success"
#define WS_STATUS_FAIL          @"fail"
#define WS_DETAILS              @"details"

//Fonts Helper
//extern NSString *const FontRegular;
//extern NSString *const FontBold;

//Entity Helper
//extern NSString *const ENTITY_GETPROFILE;//GetProfile


//File Name for Webservice
extern NSString *const FILE_DRIVER_REGISTER;//driver_register.php
extern NSString *const FILE_LOGIN;//login.php
extern NSString *const FILE_SET_PICK_TIME;//set_pick_time.php
extern NSString *const FILE_SET_DRIVER_LOCATION;//set_driver_location.php
extern NSString *const FILE_JOB_DONE;//job_done.php
extern NSString *const FILE_EDIT_PROFILE;//edit_profile.php
extern NSString *const FILE_GET_HISTORY;//get_history.php
extern NSString *const FILE_SET_DRIVER_STAT;//set_driver_stat.php
extern NSString *const FILE_GET_PROFILE;//get_profile.php
extern NSString *const FILE_DRIVER_REACHED_CLIENT;//driver_reached_client.php
extern NSString *const FILE_DRIVER_PUSH;//driver_push.php
extern NSString *const FILE_FORGOT_PASSWORD;
extern NSString *const FILE_CHANGE_PASSWORD;

//PARAMS
extern NSString *const PARAM_NAME;//name
extern NSString *const PARAM_EMAIL;//email
extern NSString *const PARAM_PASSWORD;//password
extern NSString *const PARAM_CONTACT;//contact
extern NSString *const PARAM_DATE_OF_BIRTH;//date_of_birth
extern NSString *const PARAM_DEVICE_TOKEN;//device_token
extern NSString *const PARAM_DEVICE_TYPE;//device_type
extern NSString *const PARAM_REFERENCE_NO;//reference_no
extern NSString *const PARAM_GENDER;//gender          (optional) if given then updated
extern NSString *const PARAM_RANDOM_ID;//random_id       (trip_unique_id)
extern NSString *const PARAM_TIME_OF_PICKUP;//time_of_pickup  (pickup_time)
extern NSString *const PARAM_DRIVER_ID;//driver_id       (like '2')
extern NSString *const PARAM_LATTITUDE;//lattitude
extern NSString *const PARAM_LOGITUDE;//logitude
extern NSString *const PARAM_IS_DRIVER;//is_driver
extern NSString *const PARAM_USER_ID;//user_id         (client or driver id)
extern NSString *const PARAM_TIME;//time
extern NSString *const PARAM_COUNTRY_CODE;//country_code
extern NSString *const PARAM_OLD_PASSWORD;

//Title Navigation
extern NSString *const TITLE_REGISTER;//Register
extern NSString *const TITLE_HOME;//Pick Me Up
extern NSString *const TITLE_WAITING;//Waiting
extern NSString *const TITLE_CALLOPERATOR;//ETA
extern NSString *const TITLE_THANKYOU;//ETA
extern NSString *const TITLE_FEEDBACK;//FEEDBACK
extern NSString *const TITLE_SETTING;//About
extern NSString *const TITLE_ACCOUNT;//My Account
extern NSString *const TITLE_HISTORY;//History
extern NSString *const TITLE_HISTORYDETAIL;//History Details
extern NSString *const TITLE_CHANGE_PASSWORD;

//PARAMS VALUE
extern NSString *const VALUE_GENDER_MALE;//Male
extern NSString *const VALUE_GENDER_FEMALE;//Female

