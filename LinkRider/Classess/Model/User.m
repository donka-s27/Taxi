//
//  User.m
//  Uber
//
//  Created by Elluminati - macbook on 26/06/14.
//  Copyright (c) 2014 Elluminati MacBook Pro 1. All rights reserved.
//

#import "User.h"

@implementation User
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.driver_id forKey:@"driver_id"];
    [encoder encodeObject:self.client_id forKey:@"client_id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.contact forKey:@"contact"];
    [encoder encodeObject:self.date_of_birth forKey:@"date_of_birth"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.reference_no forKey:@"reference_no"];
    [encoder encodeObject:self.lattitude forKey:@"lattitude"];
    [encoder encodeObject:self.logitude forKey:@"logitude"];
    [encoder encodeObject:self.state forKey:@"state"];
    [encoder encodeObject:self.stateId forKey:@"stateId"];
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.cityId forKey:@"cityId"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.passenger_rating forKey:@"passenger_rating"];
    [encoder encodeObject:self.passenger_rating_count forKey:@"passenger_rating_count"];
    [encoder encodeObject:self.confirm_status forKey:@"confirm_status"];
    [encoder encodeObject:self.reg_time forKey:@"reg_time"];
    [encoder encodeObject:self.is_busy forKey:@"is_busy"];
    [encoder encodeObject:self.driver_busy_stat forKey:@"driver_busy_stat"];
    [encoder encodeObject:self.country_code forKey:@"country_code"];
    [encoder encodeObject:self.login_type forKey:@"login_type"];
    [encoder encodeObject:self.point forKey:@"point"];
    [encoder encodeObject:self.thumb forKey:@"thumb"];
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.descriptions forKey:@"descriptions"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.cart_value forKey:@"cart_value"];
    [encoder encodeObject:self.is_online forKey:@"is_online"];
    [encoder encodeObject:self.manufacture_year forKey:@"manufacture_year"];
    [encoder encodeObject:self.cvv forKey:@"cvv"];
    [encoder encodeObject:self.exp forKey:@"exp"];
    [encoder encodeObject:self.main_car forKey:@"main_car"];
    [encoder encodeObject:self.sub_car forKey:@"sub_car"];
    [encoder encodeObject:self.document forKey:@"document"];
    [encoder encodeObject:self.is_driver forKey:@"is_driver"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.driver_id = [decoder decodeObjectForKey:@"driver_id"];
        self.client_id = [decoder decodeObjectForKey:@"client_id"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.contact = [decoder decodeObjectForKey:@"contact"];
        self.date_of_birth = [decoder decodeObjectForKey:@"date_of_birth"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
        self.reference_no = [decoder decodeObjectForKey:@"reference_no"];
        self.lattitude = [decoder decodeObjectForKey:@"lattitude"];
        self.logitude = [decoder decodeObjectForKey:@"logitude"];
        self.state = [decoder decodeObjectForKey:@"state"];
        self.stateId = [decoder decodeObjectForKey:@"stateId"];
        self.city = [decoder decodeObjectForKey:@"city"];
        self.cityId = [decoder decodeObjectForKey:@"cityId"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.passenger_rating = [decoder decodeObjectForKey:@"passenger_rating"];
        self.passenger_rating_count = [decoder decodeObjectForKey:@"passenger_rating_count"];
        self.confirm_status = [decoder decodeObjectForKey:@"confirm_status"];
        self.reg_time = [decoder decodeObjectForKey:@"reg_time"];
        self.is_busy = [decoder decodeObjectForKey:@"is_busy"];
        
        self.driver_busy_stat = [decoder decodeObjectForKey:@"driver_busy_stat"];
        self.country_code = [decoder decodeObjectForKey:@"country_code"];
        self.login_type = [decoder decodeObjectForKey:@"login_type"];
        self.point = [decoder decodeObjectForKey:@"point"];
        self.thumb = [decoder decodeObjectForKey:@"thumb"];
        self.token = [decoder decodeObjectForKey:@"token"];
        self.descriptions = [decoder decodeObjectForKey:@"descriptions"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.cart_value = [decoder decodeObjectForKey:@"cart_value"];
        self.is_online = [decoder decodeObjectForKey:@"is_online"];
        
        self.manufacture_year = [decoder decodeObjectForKey:@"manufacture_year"];
        self.main_car = [decoder decodeObjectForKey:@"main_car"];
        self.sub_car = [decoder decodeObjectForKey:@"sub_car"];
        self.document = [decoder decodeObjectForKey:@"document"];
        self.is_driver = [decoder decodeObjectForKey:@"is_driver"];
    }
    return self;
}

-(NSString *)is_driver{
    return [NSString stringWithFormat:@"%@",_is_driver];
}
@end
