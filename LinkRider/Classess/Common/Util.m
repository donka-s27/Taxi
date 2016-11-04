//
//  Util.m
//  MyBeautyPlan
//
//  Created by hieunguyen on 8/9/14.
//  Copyright (c) 2014 FRUITYSOLUTION. All rights reserved.
//

#import "Util.h"
#import "Macros.h"
#import <MessageUI/MessageUI.h>



#define kCalendarType NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit

@implementation Util
static EKEventStore *eventStore = nil;
+ (Util *)sharedUtil {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

+ (AppDelegate *)appDelegate {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate;
}



+(NSString *)getTeamInfoWithName:(NSString *)teamName{
    
    NSError *error;
    NSString* path = [[NSBundle mainBundle] pathForResource:teamName
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
    if (error) {
        //        NSLog(@"file content: %@",error);
    }
    return content;
}

+(BOOL)isConnectNetwork{
    
    NSString *urlString = @"http://www.google.com/";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    
    return ([response statusCode] == 200) ? YES : NO;
    
}
+(BOOL)checkString:(NSString *)sub isSubStringOf:(NSString *)large{
    
    if ([large rangeOfString:sub].location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

+(float)getLabelHight:(UILabel *)label{
    CGRect rect = [label.attributedText boundingRectWithSize:CGSizeMake(label.frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    if (IS_IPAD()) {
        return rect.size.height*2;
    }
    return rect.size.height;
}

#pragma mark --------------------------------------
#pragma mark LANGUAGE
#pragma mark --------------------------------------

+(NSString *) localized:(NSString *) key
{
    return NSLocalizedString(key,nil);
//    NSString *lang = [Util objectForKey:LANGUAGE_KEY];
//    // langCode should be set as a global variable somewhere
//    NSString *path = [[NSBundle mainBundle] pathForResource:lang ofType:@"lproj"];
//    
//    NSBundle* languageBundle = [NSBundle bundleWithPath:path];
//    return [languageBundle localizedStringForKey:key value:@"" table:nil];
}
#pragma mark --------------------------------------
#pragma mark NSUSER DEFAULT FUNCTION
#pragma mark --------------------------------------

+ (void)removeObjectForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getBoolForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+(void)setBool:(BOOL)obj forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setBool:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setObject:(id)obj forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark --------------------------------------
#pragma mark CONVERT COLOR
#pragma mark --------------------------------------
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    return [self colorWithHexString:hexString alpha:1.0];
}
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(float)alpha {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}
#pragma mark --------------------------------------
#pragma mark CONVERT DATE AND STRING
#pragma mark --------------------------------------
+(NSString *)stringFromDate:(NSDate *)date format:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *stringFromDate = [formatter stringFromDate:date];
    if (stringFromDate.length == 0) {
        return @" ";
    }
    return stringFromDate;
}
+(int)getTimezoneOffset{
    NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    return [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600.0;
}
+(BOOL)isPM{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    if (pmRange.location != NSNotFound || amRange.location != NSNotFound) {
        return YES;
    }
    return NO;
}
+(NSDate *)dateFromString:(NSString *)date format:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"] ;
    [formatter setLocale:formatterLocale];
    if ([self isPM]) {
        
        for(int i=13;i<25;i++){
            NSRange amRange = [date rangeOfString:[NSString stringWithFormat:@"T%d",i]];
            if (amRange.location != NSNotFound) {
                date = [date stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"T%d",i] withString:[NSString stringWithFormat:@"T%d",i-12]];
                date = [NSString stringWithFormat:@"%@ %@", date,[formatter PMSymbol]];
                format = [NSString stringWithFormat:@"%@ a",format];
                i = 25;
            }
            
        }
        
    }
    
    
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*[self getTimezoneOffset]]];
    NSDate *dateFromString = [formatter dateFromString:date];
    if (!dateFromString) {
        NSString *tmp = [date stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%.2d:00",[Util getTimezoneOffset]] withString:@"00:00"];
        if (![tmp isEqualToString:date]) {
            return [self dateFromString:tmp format:format];
        }
        return [NSDate date];
    }
    return dateFromString;
}
+(NSString *)replaceString:(NSString *)st1 withString:(NSString *)st2 fromString:(NSString *)str{
    if (str) {
        NSArray *arr = [str componentsSeparatedByString:st1];
        NSString *result = [arr objectAtIndex:0];
        for (int i = 1; i<arr.count;i++) {
            NSString *s = [arr objectAtIndex:i];
            result = [NSString stringWithFormat:@"%@%@%@",result,st2,s];
        }
        return result;
    }
    return @"";

}
+(int)dayLeftFromDate:(NSDate *)endDate{
    
//    NSDate *startDate = [NSDate date];
//    
//    
//    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
//                                                        fromDate:startDate
//                                                          toDate:endDate
//                                                         options:0];
//    int diff = (int)[components day];
    
    return 1;
}
+(NSMutableAttributedString *)convertStringWithFirstFont:(UIFont *)font1 andString:(NSString *)title1 withFont2:(UIFont *)font2 andString2:(NSString *)title2{
    
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: font1 forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:title1 attributes: arialDict];
    
    
    
    NSDictionary *verdanaDict = [NSDictionary dictionaryWithObject:font2 forKey:NSFontAttributeName];
    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString:title2 attributes:verdanaDict];
    
    
    [aAttrString appendAttributedString:vAttrString];
    return aAttrString;
}


+(NSMutableAttributedString *)convertStringWithFont:(UIFont *)font andString:(NSString *)title withImage:(UIImage *)image{
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSDictionary *attdistance = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:title attributes:attdistance];
    
    [att appendAttributedString:attachmentString];
    return att;
}
+(NSString *)encryptPhoneNumber:(NSString *)phone{
    if (phone.length > 6) {
        phone = [phone substringToIndex:[phone length] - 6];
        phone = [NSString stringWithFormat:@"%@xxxxxx",phone];
    }
    else if (phone.length > 3) {
        phone = [phone substringToIndex:[phone length] - 3];
        phone = [NSString stringWithFormat:@"%@xxx",phone];
    }
    return phone;
}

#pragma mark --------------------------------------
#pragma mark ALERT FUNCTION
#pragma mark --------------------------------------

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show]; 
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title andDelegate:(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title delegate:(id)delegate andTag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = tag;
    [alert show];
    
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle delegate:(id)delegate andTag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
    alert.tag = tag;
    alert.delegate = delegate;
    [alert show];
    
}


#pragma mark --------------------------------------
#pragma mark SET AND GET FRAME FUNCTION
#pragma mark --------------------------------------
+(CGRect )viewUp:(UIView *)view Up:(int)height{
    //    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y-height, view.frame.size.width, view.frame.size.height);
    return  CGRectMake(view.frame.origin.x, view.frame.origin.y-height, view.frame.size.width, view.frame.size.height);
}

+(CGRect )viewDown:(UIView *)view Down:(int)height{
    //    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+height, view.frame.size.width, view.frame.size.height);
    return CGRectMake(view.frame.origin.x, view.frame.origin.y+height, view.frame.size.width, view.frame.size.height);
}



+ (UIButton *) drawButton: (UIButton *)button {
    CGRect textRect = button.titleLabel.frame;
    
    // need to put the line at top of descenders (negative value)
    CGFloat descender = button.titleLabel.font.descender;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // set to same colour as text
    CGContextSetStrokeColorWithColor(contextRef, button.titleLabel.textColor.CGColor);
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender);
    
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender);
    
    CGContextClosePath(contextRef);
    
    CGContextDrawPath(contextRef, kCGPathStroke);
    
    return button;
}




+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}



- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
}

#pragma mark --------------------------------------
#pragma mark NOTIFICATIONS FUNCTION
#pragma mark --------------------------------------
+ (void)scheduleNotificationAfter10MinutesForDate:(NSDate *)date withMessage:(NSString *) msg
{
    // Here we cancel all previously scheduled notifications
    
    float day = [self dayLeftFromDate:date];
    
    if (day<0) {
        return;
    }
    [Util deleteNotificationOnDate:date];
    
    
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = date;
    //    NSLog(@"Notification will be shown on: %@",localNotification.fireDate);
    //
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = msg;
    localNotification.alertAction = NSLocalizedString(@"View details", nil);
    
    /* Here we set notification sound and badge on the app's icon "-1"
     means that number indicator on the badge will be decreased by one
     - so there will be no badge on the icon */
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 0;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
+ (void)scheduleNotificationForDate:(NSDate *)date withMessage:(NSString *) msg
{
    // Here we cancel all previously scheduled notifications
    float day = [self dayLeftFromDate:date];
    [Util deleteNotificationOnDate:date];
    if (day<0) {
        return;
    }
    
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
    for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
        
        if ([localNotification.alertBody isEqualToString:msg]) {
            //            NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
            
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
            
        }
        
    }
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = date;
    //    NSLog(@"Notification will be shown on: %@",localNotification.fireDate);
    
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = msg;
    localNotification.alertAction = NSLocalizedString(@"View details", nil);
    
    /* Here we set notification sound and badge on the app's icon "-1"
     means that number indicator on the badge will be decreased by one
     - so there will be no badge on the icon */
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 0;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    [self scheduleNotificationAfter10MinutesForDate:[NSDate dateWithTimeInterval:(10*60) sinceDate:date] withMessage:msg];
}


+(void)deleteNotificationOnDate:(NSDate *)date{
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
    
    for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
        
        if ([localNotification.fireDate compare:date] == NSOrderedSame) {
            //            NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
            
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification]; // delete the notification from the system
            
        }
        
    }
}


#pragma mark --------------------------------------
#pragma mark PHONE CALL
#pragma mark --------------------------------------
+(void)callPhoneNumber:(NSString *)phone{
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSString *cleanedString = [[phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *phoneURLString = [NSString stringWithFormat:@"telprompt:%@", escapedPhoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
    else{
        
        [Util showMessage:@"Call facility is not available!!!" withTitle:nil];
    }
}

#pragma mark --------------------------------------
#pragma mark FILE AND IMAGE FUNCTION
#pragma mark --------------------------------------
+(BOOL)isFilenameExits:(NSString *)name{
    NSString *imageName = [NSString stringWithFormat:@"%@.png",name];
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* foofile = [documentsPath stringByAppendingPathComponent:imageName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    if (fileExists) {
        UIImage *img = [Util getImageWithName:name];
        NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((img), 0.5)];
        
        int imageSize = (int)imageData.length;
        
        if (imageSize > 100) {
            return YES;
        }
    }
    return NO;
}
+(void)saveImage:(UIImage *)img withName:(NSString *)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];
    
    NSData *imageData = UIImagePNGRepresentation(img);
    [imageData writeToFile:savedImagePath atomically:NO];
    
    
    
}

+ (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}
+(UIImage *)getImageWithName:(NSString *)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",name] ];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}
+ (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}


+(NSData*)ScaleImage:(UIImage *)image WithMaxSize:(NSInteger)maxSize
{
    
    
    while(1)
    {
        NSData* data = UIImagePNGRepresentation(image);
        if(data.length < maxSize)
            return data;
        CGSize size = image.size;
        image = [self resizeImage:image newSize:CGSizeMake(size.width*0.9, size.height*0.9)];
    }
    
    return nil;
}

+ (CGSize)imageScale:(UIImageView *)image{
    CGFloat sx = image.frame.size.width / image.image.size.width;
    CGFloat sy = image.frame.size.height / image.image.size.height;
    CGFloat s = 1.0;
    switch (image.contentMode) {
        case UIViewContentModeScaleAspectFit:
            s = fminf(sx, sy);
            return CGSizeMake(s, s);
            break;
            
        case UIViewContentModeScaleAspectFill:
            s = fmaxf(sx, sy);
            return CGSizeMake(s, s);
            break;
            
        case UIViewContentModeScaleToFill:
            return CGSizeMake(sx, sy);
            
        default:
            return CGSizeMake(s, s);
    }
}


+ (UIImage*)imageWithImage:(UIImage *)image convertToWidth:(float)width covertToHeight:(float)height {
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}
+(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
{
    
    UIFont *font = [UIFont fontWithName:@"Raleway-Medium" size:30];

    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(0, -5, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    [text drawInRect:CGRectIntegral(rect) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
+(void)shareWithImage:(UIImage *)image
               onView:(UIViewController *)view
             delegate:(id)delegate
          WithSuccess:(void (^)(void))success
              failure:(void (^)(NSString *))failure{
    if ([MFMailComposeViewController canSendMail]) {
        // device is configured to send mail
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = delegate;
        [mail setSubject:@"Check out this image!"];
        
        
        NSData *myData = UIImageJPEGRepresentation(image, 1);
        [mail addAttachmentData:myData mimeType:@"image/png" fileName:[NSString stringWithFormat:@"image.png"]];
        
        NSString *emailBody = @"My cool image is attached";
        [mail setMessageBody:emailBody isHTML:NO];
        [view presentViewController:mail animated:YES completion:NULL];
    }
    else{
        failure(nil);
        
    }
}
+ (UIImage*)imageWithImage:(UIImage *)image convertToHeight:(float)height {
    float ratio = image.size.height / height;
    float width = image.size.width / ratio;
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}

+ (UIImage*)imageWithImage:(UIImage *)image convertToWidth:(float)width {
    float ratio = image.size.width / width;
    float height = image.size.height / ratio;
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}

+ (UIImage*)imageWithImage:(UIImage *)image fitInsideWidth:(float)width fitInsideHeight:(float)height {
    if (image.size.height >= image.size.width) {
        return [Util imageWithImage:image convertToWidth:width];
    } else {
        return [Util imageWithImage:image convertToHeight:height];
    }
}

+ (UIImage*)imageWithImage:(UIImage *)image fitOutsideWidth:(float)width fitOutsideHeight:(float)height {
    if (image.size.height >= image.size.width) {
        return [Util imageWithImage:image convertToHeight:height];
    } else {
        return [Util imageWithImage:image convertToWidth:width];
    }
}

+ (UIImage*)imageWithImage:(UIImage *)image cropToWidth:(float)width cropToHeight:(float)height {
    CGSize size = [image size];
    CGRect rect = CGRectMake(((size.width-width) / 2.0f), ((size.height-height) / 2.0f), width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage * img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return img;
}


#pragma mark --------------------------------------
#pragma mark EVENT FUNCTION
#pragma mark --------------------------------------

+ (void)requestAccess:(void (^)(BOOL granted, NSError *error))callback;
{
    
    if (eventStore == nil) {
        eventStore = [[EKEventStore alloc] init];
    }
    // request permissions
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:callback];
}



+ (BOOL)addEventAt:(NSDate*)eventDate withTitle:(NSString*)title inLocation:(NSString*)location eventId:(NSString *)calendarIdentifier notes:(NSString *)note andURL:(NSString *)url
{
    
    NSDate *startDate = [NSDate date];
    
    int diff = [eventDate compare:startDate];
    
    if (diff<0) {
        return YES;
    }
    else{
        if (title.length == 0) {
            title = @" ";
        }
        if (location.length == 0) {
            location = @" ";
        }
        if (note.length == 0) {
            note = @" ";
        }
        if (url.length == 0) {
            url = @"";
        }
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
        event.title = title;
        event.startDate = eventDate;
        event.endDate = [eventDate dateByAddingTimeInterval:60*60*2];  // Duration 2 hr
        event.location = location;
        event.notes = note;
        event.URL = [NSURL URLWithString:url];
        
        [event setCalendar:[eventStore defaultCalendarForNewEvents]];
        NSError *err = nil;
        [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        if (!err) {
            NSString *savedEventId = event.eventIdentifier;  // Store this so you can access this event later
            [Util setObject:savedEventId forKey:calendarIdentifier];
            
            return YES;
        }
        else{
            return NO;
        }
    }
    
    
}
+ (BOOL)editEventAt:(NSDate*)eventDate withTitle:(NSString*)title inLocation:(NSString*)location eventId:(NSString *)calendarIdentifier notes:(NSString *)note andURL:(NSString *)url{
    
    NSDate *startDate = [NSDate date];
    
    int diff = [eventDate compare:startDate];
    
    if (diff<0) {
        [self deleteEventAteventId:calendarIdentifier];
        return YES;
    }
    else{
        if (title.length == 0) {
            title = @" ";
        }
        if (location.length == 0) {
            location = @" ";
        }
        if (note.length == 0) {
            note = @" ";
        }
        if (url.length == 0) {
            url = @"";
        }
        
        
        EKEvent *event = [eventStore eventWithIdentifier:[Util objectForKey:calendarIdentifier]];
        // Uncomment below if you want to create a new event if savedEventId no longer exists
        // if (event == nil)
        //   event = [EKEvent eventWithEventStore:store];
        if (event) {
            NSError *err = nil;
            event.title = title;
            event.startDate = eventDate;
            event.endDate = [event.startDate dateByAddingTimeInterval:60*60*2];  // Duration 2 hr
            event.location = location;
            event.notes = note;
            event.URL = [NSURL URLWithString:url];
            [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            return YES;
        }
    }
    
    
    
    return NO;
}

+ (BOOL)deleteEventAteventId:(NSString *)calendarIdentifier{
    
    EKEvent* eventToRemove = [eventStore eventWithIdentifier:[Util objectForKey:calendarIdentifier]];
    if (eventToRemove) {
        NSError* err = nil;
        [eventStore removeEvent:eventToRemove span:EKSpanThisEvent commit:YES error:&err];
        if (!err) {
            return YES;
        }
        return NO;
    }
    
    
    return NO;
}
+(NSString *)upperFirstChar:(NSString *)input{
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    

    /* get first char */
    NSString *firstChar = [input substringToIndex:1];
    
    /* remove any diacritic mark */
    NSString *folded = [firstChar stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:locale];
    
    /* create the new string */
    NSString *result = [[folded uppercaseString] stringByAppendingString:[input substringFromIndex:1]];
    return result;
}

+ (void)saveUser:(User *)object{
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:USER_KEY];
    [defaults synchronize];
    
}

+ (User *)loadUser{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:USER_KEY];
    User *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

+ (void)saveTrips:(Trips *)object {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"GTRIPSKEY"];
    [defaults synchronize];
    
}

+ (Trips *)loadTrips {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"GTRIPSKEY"];
    Trips *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}
@end
