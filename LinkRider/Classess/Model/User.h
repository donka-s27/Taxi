//
//  User.h
//  Uber
//
//  Created by Elluminati - macbook on 26/06/14.
//  Copyright (c) 2014 Elluminati MacBook Pro 1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DriverCar.h"
#import "Driver.h"
@interface User : NSObject
@property(nonatomic,copy)NSString *driver_id;
@property(nonatomic,copy)NSString *client_id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSString *contact;
@property(nonatomic,copy)NSString *date_of_birth;
@property(nonatomic,copy)NSString *gender;
@property(nonatomic,copy)NSString *reference_no;
@property(nonatomic,copy)NSString *lattitude;
@property(nonatomic,copy)NSString *logitude;
@property(nonatomic,copy)NSString *passenger_rating;
@property(nonatomic,copy)NSString *passenger_rating_count;
@property(nonatomic,copy)NSString *confirm_status;
@property(nonatomic,copy)NSString *reg_time;
@property(nonatomic,copy)NSString *is_busy;
@property(nonatomic,copy)NSString *driver_busy_stat;
@property(nonatomic,copy)NSString *country_code;
@property(nonatomic,copy)NSString *login_type;
@property(nonatomic,copy)NSString *thumb;
@property(nonatomic,copy)NSString *point;
@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString *descriptions;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *stateId;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *cityId;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *cart_value;
@property(nonatomic,copy)NSString *is_online;
@property(nonatomic,copy)NSString *manufacture_year;
@property(nonatomic,copy)NSString *cvv;
@property(nonatomic,copy)NSString *exp;
@property(nonatomic,copy)NSString *main_car;
@property(nonatomic,copy)NSString *sub_car;
@property(nonatomic,copy)UIImage *main_car_image;
@property(nonatomic,copy)UIImage *sub_car_image;
@property(nonatomic,copy)NSString *car_status;
@property(nonatomic,copy)NSString *document;
@property(nonatomic,copy)NSString *is_driver;

@property(nonatomic,strong)DriverCar *car;
@property(nonatomic,strong)Driver *driver;
@end
