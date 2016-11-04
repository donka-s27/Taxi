//
//  Global.h
//  LinkRider
//
//  Created by hieu nguyen on 7/3/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trips.h"
@interface Global : NSObject
extern NSString *deviceTokenString;
extern User *gUser;
extern Trips *gTrip;
extern NSDictionary *notificationsDic;
extern NSArray* gArrState;
@end
