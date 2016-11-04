//
//  AppDelegate.m
//  LinkRider
//
//  Created by hieu nguyen on 6/22/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PayPalMobile.h"
#import "StartTripViewController.h"
#import "OnlineStartTripViewController.h"
#import "RatingTripViewController.h"
#import "RattingPassengerViewController.h"
#import "ModelManager.h"
#import "OnlineConfirmViewController.h"
#import "OrderConfirmViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    //    [GIDSignIn sharedInstance].delegate = self;
    
    // Override point for customization after application launch.
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        //        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
        //         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    [self performSelectorInBackground:@selector(getListState) withObject:nil];
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : kPayPalClientId,
                                                           PayPalEnvironmentSandbox : kPayPalClientId}];
    NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notification != nil) {
        notificationsDic = notification;
        NSDictionary *alert = [[notificationsDic objectForKey:@"aps"] objectForKey:@"alert"];
        if ([alert isKindOfClass:[NSDictionary class]]) {
            NSString *action = [alert valueForKey:@"action"];
            if ([action isEqualToString:@"promotion"]) {
                notificationsDic = nil;
            }
        }
        self.gotNotifcation = YES;
        
    }
    
    
    return YES;
}

- (void)getListState{
    [ModelManager getListStateWithSuccess:^(NSArray *arrResult) {
        
    } failure:^(NSString *err) {
        [self getListState];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    application.applicationIconBadgeNumber = 0;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    
    NSRange range = [urlStr rangeOfString:@"oauth2"];
    if (range.location == NSNotFound) {
        
        return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                              openURL:url
                                                    sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                           annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }else{
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];}
    
}

//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
//
//
//        return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                              openURL:url
//                                                    sourceApplication:sourceApplication
//                                                           annotation:annotation];
//
//
//}
- (void)applicationWillTerminate:(UIApplication *)application {
    
    [self saveContext];
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Device token is: %@", token);
    
    deviceTokenString = token;
    
    [Util setObject:deviceTokenString forKey:@"Token"];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSDictionary *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    notificationsDic = userInfo;
    if ([alert isKindOfClass:[NSDictionary class]]) {
        NSString *action = [alert valueForKey:@"action"];
        if ([action isEqualToString:@"redeemApproval"]||[action isEqualToString:@"transferApproval"]) {
            [Util showMessage:[alert objectForKey:@"body"] withTitle:[Util localized:@"app_name"] cancelButtonTitle:[Util localized:@"title_cancel"] otherButtonTitles:[Util localized:@"title_ok"] delegate:self andTag:2];
            
            return;
        }
        if ([action isEqualToString:@"updateApproval"]) {
            [Util showMessage:[alert objectForKey:@"body"] withTitle:[Util localized:@"app_name"]];
            notificationsDic = nil;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [ModelManager getUserProfileWithSuccess:^{
                    
                } failure:^(NSString *err) {
                    
                }];
            });
            return;
        }
        if ([action isEqualToString:@"createRequest"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DRIVER_RECEIVE_REQUEST_KEY object:nil userInfo:notificationsDic];
            return;
        }
    }
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
    {
        NSDictionary *alert = [[notificationsDic objectForKey:@"aps"] objectForKey:@"alert"];
        if ([alert isKindOfClass:[NSDictionary class]]) {
            [Util showMessage:[alert objectForKey:@"body"] withTitle:[Util localized:@"app_name"] cancelButtonTitle:[Util localized:@"title_cancel"] otherButtonTitles:[Util localized:@"title_ok"] delegate:self andTag:1];
        }
        
    }
    else{
        [self handleNotifications];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if (alertView.tag==2) {
            [self gotoTransactionHistory];
        }
        else{
            [self handleNotifications];
        }
        
    }
    
}
-(void)gotoTransactionHistory{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_TRANSACTION_HISTORY_KEY object:nil userInfo:notificationsDic];
}
-(void)handleNotifications{
    NSDictionary *alert = [[notificationsDic objectForKey:@"aps"] objectForKey:@"alert"];
    if ([alert isKindOfClass:[NSDictionary class]]) {
        NSString *action = [alert valueForKey:@"action"];
        if ([action isEqualToString:DRIVER_REGISTER_APPROVE]) {
            [Util showMessage:[alert valueForKey:@"body"] withTitle:[Util localized:@"app_name"]];
            //            [Util showMessage:[Util localized:@"msg_driver_approved"] withTitle:[Util localized:@"app_name"]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [ModelManager loginWithUser:gUser andToken:deviceTokenString Status:YES withSuccess:^(NSString *u) {
                    
                } failure:^(NSString *err) {
                    
                }];
            });
        }
        if ([action isEqualToString:PUSH_KEY_PROMOTION]) {
            [Util showMessage:[alert valueForKey:@"body"] withTitle:[Util localized:@"app_name"]];
        }
        if (![gUser.driver.isOnline boolValue]) {
            if ([action isEqualToString:@"createRequest"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVE_ORDER_REQUEST_KEY object:nil userInfo:notificationsDic];
            }
            else if ([action isEqualToString:@"driverConfirm"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:DRIVER_CONFIRM_KEY object:nil userInfo:notificationsDic];
            }
            else if ([action isEqualToString:@"startTrip"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:START_TRIP_KEY object:nil userInfo:notificationsDic];
            }
            else if ([action isEqualToString:@"endTrip"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:END_TRIP_KEY object:nil userInfo:notificationsDic];
            }
            else if ([action isEqualToString:@"cancelTrip"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"resetAllPoint" object:nil userInfo:notificationsDic];
                [[NSNotificationCenter defaultCenter] postNotificationName:CANCEL_TRIP_KEY object:nil userInfo:notificationsDic];
                return;
            }
            else{
                notificationsDic = nil;
            }
        }
        else{
            if ([action isEqualToString:@"createRequest"]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:DRIVER_RECEIVE_REQUEST_KEY object:nil userInfo:notificationsDic];
            }
            else if ([action isEqualToString:@"cancelTrip"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"resetAllPoint" object:nil userInfo:notificationsDic];
                [[NSNotificationCenter defaultCenter] postNotificationName:DRIVER_CANCEL_TRIP_KEY object:nil userInfo:notificationsDic];
            }
            else if ([action isEqualToString:@"cancelRequest"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:PASSENGER_CANCEL_REQUEST object:nil userInfo:notificationsDic];
                
            }
            
            else{
                notificationsDic = nil;
            }
        }
        
    }
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   
    [[NSNotificationCenter defaultCenter] postNotificationName:WILL_ENTER_FORCE_GROUND object:WILL_ENTER_FORCE_GROUND];
    UIViewController *current = (UIViewController*)[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    if ([current isKindOfClass:[StartTripViewController class]]||[current isKindOfClass:[OnlineStartTripViewController class]]||[current isKindOfClass:[RatingTripViewController class]]||[current isKindOfClass:[RattingPassengerViewController class]]) {
        return;
    }
    
    //    NSDictionary *alert = [[notificationsDic objectForKey:@"aps"] objectForKey:@"alert"];
    //    if ([alert isKindOfClass:[NSDictionary class]]) {
    //        [Util showMessage:[alert objectForKey:@"body"] withTitle:[Util localized:@"app_name"] andDelegate:self];
    //    }
    
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.pt.LinkRider" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LinkRider" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LinkRider.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error{
    
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
