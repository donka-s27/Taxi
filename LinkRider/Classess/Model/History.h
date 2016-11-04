//
//  History.h
//  Uber
//
//  Created by Elluminati - macbook on 27/06/14.
//  Copyright (c) 2014 Elluminati MacBook Pro 1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject

@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *action;
@property(nonatomic,copy)NSString *dateCreated;
@property(nonatomic,copy)NSString *destination;
@property(nonatomic,copy)NSString *transactionId;
@property(nonatomic,copy)NSString *tripId;
@property(nonatomic,copy)NSString *type;


@end

