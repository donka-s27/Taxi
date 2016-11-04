//
//  CityObj.m
//  VINPRANM
//
//  Created by Pham Diep on 9/27/16.
//  Copyright © 2016 Fruity Solution. All rights reserved.
//

#import "CityObj.h"

@implementation CityObj
- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        _cityId = [Validator getSafeString:dict[@"cityId"]];
        _cityName = [Validator getSafeString:dict[@"cityName"]];
    }
    return self;
}
@end
