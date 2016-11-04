//
//  BusAnnotation.h
//  Bus
//
//  Created by MAC on 2/11/14.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface BusAnnotation : NSObject<MKAnnotation>
{
    //NSString* busName;
}

@property (nonatomic, assign)CLLocationCoordinate2D coordinate;

//@property (nonatomic, strong) NSString* busName;
//@property (nonatomic, strong) NSString* busstopType;
//@property (nonatomic, copy) NSString * title;
//@property (nonatomic, copy) NSString * image;
//@property (nonatomic, copy) NSString * address;

@end
