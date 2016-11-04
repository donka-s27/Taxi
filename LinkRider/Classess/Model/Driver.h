//
//  Driver.h
//  LinkRider
//
//  Created by hieu nguyen on 7/15/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Driver : NSObject
@property(nonatomic,copy)NSString *bankAccount;
@property(nonatomic,copy)NSString *document;
@property(nonatomic,copy)NSString *driverRate;
@property(nonatomic,copy)NSString *driverRateCount;
@property(nonatomic,copy)NSString *isActive;
@property(nonatomic,copy)NSString *isOnline;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *driverName;
@property(nonatomic,copy)NSString *imageDriver;
@property(nonatomic,copy)NSString *carPlate;
@property(nonatomic,copy)NSString *carImage;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *update_pending;
@end
