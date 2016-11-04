//
//  CityObj.h
//  VINPRANM
//
//  Created by Pham Diep on 9/27/16.
//  Copyright © 2016 Fruity Solution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityObj : NSObject
@property NSString* cityId;
@property NSString* cityName;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
