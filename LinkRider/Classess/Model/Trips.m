//
//  Trips.m
//  LinkRider
//
//  Created by hieu nguyen on 7/7/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "Trips.h"

@implementation Trips
- (void)encodeWithCoder:(NSCoder *)encoder {

    [encoder encodeObject:self.tripId forKey:@"tripId"];
    [encoder encodeObject:self.link forKey:@"link"];
    [encoder encodeObject:self.startLocation forKey:@"startLocation"];
    [encoder encodeObject:self.endLocation forKey:@"endLocation"];
    [encoder encodeObject:self.passengerId forKey:@"passengerId"];
    [encoder encodeObject:self.driverId forKey:@"driverId"];
    [encoder encodeObject:self.startTime forKey:@"startTime"];
    [encoder encodeObject:self.endTime forKey:@"endTime"];
    [encoder encodeObject:self.distance forKey:@"distance"];
    [encoder encodeObject:self.status forKey:@"status"];
    [encoder encodeObject:self.estimateFare forKey:@"estimateFare"];
    [encoder encodeObject:self.actualFare forKey:@"actualFare"];
    [encoder encodeObject:self.driverRate forKey:@"driverRate"];
    [encoder encodeObject:self.passengerRate forKey:@"passengerRate"];
    [encoder encodeObject:self.dateCreated forKey:@"dateCreated"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.tripId = [decoder decodeObjectForKey:@"tripId"];
        self.link = [decoder decodeObjectForKey:@"link"];
        self.startLocation = [decoder decodeObjectForKey:@"startLocation"];
        self.endLocation = [decoder decodeObjectForKey:@"endLocation"];
        self.passengerId = [decoder decodeObjectForKey:@"link"];
        self.driverId = [decoder decodeObjectForKey:@"startLocation"];
        self.startTime = [decoder decodeObjectForKey:@"endLocation"];
        self.endTime = [decoder decodeObjectForKey:@"link"];
        self.distance = [decoder decodeObjectForKey:@"startLocation"];
        self.status = [decoder decodeObjectForKey:@"endLocation"];
        self.estimateFare = [decoder decodeObjectForKey:@"link"];
        self.actualFare = [decoder decodeObjectForKey:@"startLocation"];
        self.driverRate = [decoder decodeObjectForKey:@"endLocation"];
        self.passengerRate = [decoder decodeObjectForKey:@"link"];
        self.dateCreated = [decoder decodeObjectForKey:@"startLocation"];

    }
    return self;
}
-(void)setStartLocationWithLatitude:(float)lat longitude:(float)lon andTitle:(NSString *)title{
    MKPlacemark *placemarkFrom = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon) addressDictionary:nil] ;
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:placemarkFrom];
    [fromItem setName:title];
    self.startLocation = fromItem;
}
-(void)setEndLocationWithLatitude:(float)lat longitude:(float)lon andTitle:(NSString *)title{
    MKPlacemark *placemarkFrom = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon) addressDictionary:nil] ;
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:placemarkFrom];
    [fromItem setName:title];
    self.endLocation = fromItem;
}
@end
