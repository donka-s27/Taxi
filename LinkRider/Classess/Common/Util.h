//
//  Util.h
//  MyBeautyPlan
//
//  Created by hieunguyen on 8/9/14.
//  Copyright (c) 2014 FRUITYSOLUTION. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "User.h"
#import "Trips.h"

#import <EventKit/EventKit.h>

@interface Util : NSObject{
    
}

+ (Util *)sharedUtil;

+(BOOL)isConnectNetwork;
#pragma mark --------------------------------------
#pragma mark LANGUAGE
#pragma mark --------------------------------------

+(NSString *) localized:(NSString *) key;

#pragma mark --------------------------------------
#pragma mark NSUSER DEFAULT FUNCTION
#pragma mark --------------------------------------

+ (void)removeObjectForKey:(NSString *)key;
+(BOOL)getBoolForKey:(NSString *)key;

+(void)setBool:(BOOL)obj forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;
+ (void)setObject:(id)obj forKey:(NSString *)key;

#pragma mark --------------------------------------
#pragma mark CONVERT COLOR
#pragma mark --------------------------------------
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(float)alpha;
#pragma mark --------------------------------------
#pragma mark CONVERT DATE AND STRING
#pragma mark --------------------------------------
+(NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
+(NSDate *)dateFromString:(NSString *)date format:(NSString *)format;
+(NSString *)replaceString:(NSString *)st1 withString:(NSString *)st2 fromString:(NSString *)str;
+(int)dayLeftFromDate:(NSDate *)endDate;
+(BOOL)checkString:(NSString *)sub isSubStringOf:(NSString *)large;
+ (NSString *)upperFirstChar:(NSString *)input;

+(NSMutableAttributedString *)convertStringWithFirstFont:(UIFont *)font1 andString:(NSString *)title1 withFont2:(UIFont *)font2 andString2:(NSString *)title2;
+(NSMutableAttributedString *)convertStringWithFont:(UIFont *)font andString:(NSString *)title withImage:(UIImage *)image;
+(NSString *)encryptPhoneNumber:(NSString *)phone;
#pragma mark --------------------------------------
#pragma mark ALERT FUNCTION
#pragma mark --------------------------------------

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title andDelegate:(id)delegate;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title delegate:(id)delegate andTag:(NSInteger)tag;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle delegate:(id)delegate andTag:(NSInteger)tag;


#pragma mark --------------------------------------
#pragma mark SET AND GET FRAME FUNCTION
#pragma mark --------------------------------------
+(CGRect )viewUp:(UIView *)view Up:(int)height;
+(CGRect )viewDown:(UIView *)view Down:(int)height;
+ (UIButton *) drawButton: (UIButton *)button;
+(float)getLabelHight:(UILabel *)label;


#pragma mark --------------------------------------
#pragma mark TIMEZONE
#pragma mark --------------------------------------
+(int)getTimezoneOffset;
#pragma mark --------------------------------------
#pragma mark PHONE CALL
#pragma mark --------------------------------------
+(void)callPhoneNumber:(NSString *)phone;


#pragma mark --------------------------------------
#pragma mark FILE AND IMAGE FUNCTION
#pragma mark --------------------------------------
+(void)saveImage:(UIImage *)img withName:(NSString *)name;

+(UIImage *)getImageWithName:(NSString *)name;

+ (NSString *)documentsPathForFileName:(NSString *)name;

+ (BOOL)isFilenameExits:(NSString *)name;

+(CGSize)imageScale:(UIImageView *)image;

+(void)shareWithImage:(UIImage *)image
               onView:(UIViewController *)view
             delegate:(id)delegate
          WithSuccess:(void (^)(void))success
              failure:(void (^)(NSString *))failure;
+(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point;
+ (UIImage*)imageWithImage:(UIImage *)image convertToWidth:(float)width covertToHeight:(float)height;
+ (UIImage*)imageWithImage:(UIImage *)image convertToHeight:(float)height;
+ (UIImage*)imageWithImage:(UIImage *)image convertToWidth:(float)width;
+ (UIImage*)imageWithImage:(UIImage *)image fitInsideWidth:(float)width fitInsideHeight:(float)height;
+ (UIImage*)imageWithImage:(UIImage *)image fitOutsideWidth:(float)width fitOutsideHeight:(float)height;
+ (UIImage*)imageWithImage:(UIImage *)image cropToWidth:(float)width cropToHeight:(float)height;

+ (void)requestAccess:(void (^)(BOOL granted, NSError *error))callback;
#pragma mark --------------------------------------
#pragma mark EVENT FUNCTION
#pragma mark --------------------------------------
+ (BOOL)addEventAt:(NSDate*)eventDate withTitle:(NSString*)title inLocation:(NSString*)location eventId:(NSString *)calendarIdentifier notes:(NSString *)note andURL:(NSString *)url ;

+ (BOOL)editEventAt:(NSDate*)eventDate withTitle:(NSString*)title inLocation:(NSString*)location eventId:(NSString *)calendarIdentifier notes:(NSString *)note andURL:(NSString *)url;

+ (BOOL)deleteEventAteventId:(NSString *)calendarIdentifier ;
+ (void)saveUser:(User *)object;
+ (User *)loadUser;
+ (void)saveTrips:(Trips *)object;
+ (Trips *)loadTrips;
@end
