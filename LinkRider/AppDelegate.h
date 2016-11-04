//
//  AppDelegate.h
//  LinkRider
//
//  Created by hieu nguyen on 6/22/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "OrderConfirmViewController.h"
//#import <GooglePlus/GooglePlus.h>
#import <Google/SignIn.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (assign, nonatomic) BOOL gotNotifcation;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

