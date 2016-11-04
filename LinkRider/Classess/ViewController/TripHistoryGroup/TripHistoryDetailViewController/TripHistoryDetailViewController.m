//
//  TripHistoryDetailViewController.m
//  LinkRider
//
//  Created by hieu nguyen on 7/2/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "TripHistoryDetailViewController.h"

@interface TripHistoryDetailViewController ()

@end

@implementation TripHistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:NO animated:YES];
    self.navigationController.navigationBarHidden = NO;
    [self setText];
    
}
-(void)setText{
    [self.lblHeaderTitle setTitle:[Util localized:@"header_history"]];
    
    [self.btnBack setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontAwesomeFontOfSize:20], NSFontAttributeName,
                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                          nil]
                                forState:UIControlStateNormal];
    
    [self.btnBack setTitle:[NSString fontAwesomeIconStringForEnum:FALongArrowLeft] ];
    [self.btnBack setTarget:self];
    [self.btnBack setAction:@selector(onBack)];
    
    self.lblTripDetail.text = [Util localized:@"lbl_trip_detail"];
    self.lblIdDriver.text = [Util localized:@"lbl_trip_id"];;
    self.lblLink.text = [Util localized:@"lbl_link"];;

    self.lblEndtime.text = [Util localized:@"lbl_end_time"];;
    self.lblDeparture.text = [Util localized:@"lbl_departure"];;
    self.lblDestination.text = [Util localized:@"lbl_destination"];;
    self.lblTime.text = [Util localized:@"lbl_time"];;
    self.lblLength.text = [Util localized:@"lbl_length"];;
    self.lblTotalPoint.text = [Util localized:@"lbl_total_point"];
    self.lblDepartureValue.textColor = self.lblDeparture.textColor;
    self.lblDepartureValue.font = self.lblDeparture.font;
    self.lblDestinationValue.textColor = self.lblDeparture.textColor;
    self.lblDestinationValue.font = self.lblDeparture.font;
    self.scrollView.contentSize = CGSizeMake(320, self.lblTotalPoint.frame.origin.y+self.lblTotalPoint.frame.size.height+20);
    
    self.lblIdDriverValue.text = _currentTrip.tripId;
    self.lblLinkValue.text = _currentTrip.link;

    self.lblEndtimeValue.text = _currentTrip.endTime;
    self.lblDepartureValue.text = _currentTrip.startLocation.name;
    self.lblDestinationValue.text = _currentTrip.endLocation.name;
    self.lblTimeValue.text = _currentTrip.totalTime;
    self.lblLengthValue.text = [NSString stringWithFormat:@"%@ km",_currentTrip.distance];
    self.lblTotalPointValue.text = _currentTrip.actualFare;
}
-(void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
