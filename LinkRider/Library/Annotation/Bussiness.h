//
//  Bussiness.h
//  District
//
//  Created by duc le on 4/26/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bussiness : NSObject

@property (nonatomic, strong) NSString* objectID;
@property (nonatomic, strong) NSArray* imageURLs;
@property (nonatomic, strong) NSString* thumbURL;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* website;
@property (nonatomic, strong) NSString* phone;

@property (nonatomic, strong) NSString* price;
@property (nonatomic, strong) NSString* fax;
@property (nonatomic, strong) NSString* address;
@property (nonatomic, assign) float lattitude;
@property (nonatomic, assign) float longtitude;
@property (nonatomic, strong) NSString* introduction;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, assign) NSInteger commentNumber;
@property (nonatomic, strong) NSString* dateCreated;
@property (nonatomic, strong) NSString* startDate;
@property (nonatomic, strong) NSString* endDate;
@property (nonatomic, assign) float rate;
@property (nonatomic, strong) NSArray* categories;
@property (nonatomic, strong) NSString* categoryName;
@property (nonatomic, strong) NSString* descriptions;


@property (nonatomic, assign) NSInteger type;
@end
