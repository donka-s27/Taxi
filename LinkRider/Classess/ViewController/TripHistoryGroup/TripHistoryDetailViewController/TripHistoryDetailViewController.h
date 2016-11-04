//
//  TripHistoryDetailViewController.h
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trips.h"
#import "CBAutoScrollLabel.h"
@interface TripHistoryDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *lblHeaderTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblTripDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblIdDriver;
@property (weak, nonatomic) IBOutlet UILabel *lblLink;

@property (weak, nonatomic) IBOutlet UILabel *lblEndtime;
@property (weak, nonatomic) IBOutlet UILabel *lblDeparture;
@property (weak, nonatomic) IBOutlet UILabel *lblDestination;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblLength;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPoint;


@property (weak, nonatomic) IBOutlet UILabel *lblIdDriverValue;
@property (weak, nonatomic) IBOutlet UILabel *lblLinkValue;

@property (weak, nonatomic) IBOutlet UILabel *lblEndtimeValue;
@property (weak, nonatomic) IBOutlet CBAutoScrollLabel *lblDepartureValue;
@property (weak, nonatomic) IBOutlet CBAutoScrollLabel *lblDestinationValue;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeValue;
@property (weak, nonatomic) IBOutlet UILabel *lblLengthValue;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPointValue;

@property (strong, nonatomic) Trips *currentTrip;
@end
