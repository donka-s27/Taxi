//
//  StateObj.m
//  VINPRANM
//
//  Created by Pham Diep on 9/27/16.
//  Copyright © 2016 Fruity Solution. All rights reserved.
//

#import "StateObj.h"

@implementation StateObj
- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        _stateId = [Validator getSafeString:dict[@"stateId"]];
        _stateName = [Validator getSafeString:dict[@"stateName"]];
        NSArray *arrDictCities = dict[@"stateCities"];
        NSMutableArray *arrCities = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in arrDictCities) {
            CityObj *cityObj = [[CityObj alloc] initWithDict:dic];
            [arrCities addObject:cityObj];
        }
        _arrCites = arrCities.copy;
        
    }
    return self;
}


@end
