//
//  Trips.h
//  LinkRider
//
//  Created by hieu nguyen on 7/7/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Driver.h"
#import "User.h"

@interface Trips : NSObject
@property (strong, nonatomic) NSString *tripId;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) MKMapItem *startLocation;
@property (strong, nonatomic) MKMapItem *endLocation;
@property (strong, nonatomic) NSString *passengerId;
@property (strong, nonatomic) NSString *driverId;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *estimateFare;
@property (strong, nonatomic) NSString *actualFare;
@property (strong, nonatomic) NSString *actualEarn;
@property (strong, nonatomic) NSString *driverRate;
@property (strong, nonatomic) NSString *passengerRate;
@property (strong, nonatomic) NSString *dateCreated;
@property (strong, nonatomic) NSString *totalTime;
@property (strong, nonatomic) Driver *driver;
@property (strong, nonatomic) User *passenger;


-(void)setStartLocationWithLatitude:(float)lat longitude:(float)lon andTitle:(NSString *)title;
-(void)setEndLocationWithLatitude:(float)lat longitude:(float)lon andTitle:(NSString *)title;

@end
