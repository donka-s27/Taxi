//
//  StateObj.h
//  VINPRANM
//
//  Created by Pham Diep on 9/27/16.
//  Copyright © 2016 Fruity Solution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityObj.h"
@interface StateObj : NSObject
@property (strong, nonatomic) NSString *stateId;
@property (strong, nonatomic) NSString *stateName;
@property (strong, nonatomic) NSArray* arrCites;
- (instancetype)initWithDict:(NSDictionary*)dict;
@end
