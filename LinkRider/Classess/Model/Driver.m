//
//  Driver.m
//  LinkRider
//
//  Created by hieu nguyen on 7/15/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "Driver.h"

@implementation Driver
- (void)encodeWithCoder:(NSCoder *)encoder {
    
    //Encode properties, other class variables, etc
    
    [encoder encodeObject:self.bankAccount forKey:@"passenger_rating"];
    [encoder encodeObject:self.document forKey:@"passenger_rating_count"];
    [encoder encodeObject:self.driverRate forKey:@"confirm_status"];
    [encoder encodeObject:self.driverRateCount forKey:@"reg_time"];
    [encoder encodeObject:self.isActive forKey:@"is_busy111"];
    [encoder encodeObject:self.isOnline forKey:@"driver_busy_stat"];
    [encoder encodeObject:self.status forKey:@"country_code"];
    [encoder encodeObject:self.driverName forKey:@"login_type"];
    [encoder encodeObject:self.imageDriver forKey:@"point"];
    [encoder encodeObject:self.carPlate forKey:@"thumb"];
    [encoder encodeObject:self.carImage forKey:@"token"];
    [encoder encodeObject:self.update_pending forKey:@"descriptions"];
    [encoder encodeObject:self.phone forKey:@"phone"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        
        self.bankAccount = [decoder decodeObjectForKey:@"passenger_rating"];
        self.document = [decoder decodeObjectForKey:@"passenger_rating_count"];
        self.driverRate = [decoder decodeObjectForKey:@"confirm_status"];
        self.driverRateCount = [decoder decodeObjectForKey:@"reg_time"];
        self.isActive = [decoder decodeObjectForKey:@"is_busy111"];
        
        self.isOnline = [decoder decodeObjectForKey:@"driver_busy_stat"];
        self.status = [decoder decodeObjectForKey:@"country_code"];
        self.driverName = [decoder decodeObjectForKey:@"login_type"];
        self.imageDriver = [decoder decodeObjectForKey:@"point"];
        self.carPlate = [decoder decodeObjectForKey:@"thumb"];
        self.carImage = [decoder decodeObjectForKey:@"token"];
        self.update_pending = [decoder decodeObjectForKey:@"descriptions"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
    }
    return self;
}


-(NSString *)isActive{
    return [NSString stringWithFormat:@"%@",_isActive];
}
-(NSString *)isOnline{
    return [NSString stringWithFormat:@"%@",_isOnline   ];
}
@end
