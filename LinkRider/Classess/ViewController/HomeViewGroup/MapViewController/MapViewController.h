//
//  MapViewController.h
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MPGTextField.h"
#import "WaitingViewController.h"
@interface MapViewController : UIViewController<UITextFieldDelegate,MKMapViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,MPGTextFieldDelegate>{
    MKPointAnnotation *fromPoint;
    MKPointAnnotation *toPoint;
     NSMutableArray *data;
    MKUserLocation *currentLocation;
    BOOL isEdittingTfFrom;
}
@property (weak, nonatomic) IBOutlet UINavigationItem *lblHeaderTitle;
@property (strong, nonatomic) IBOutlet MKMapView *mapview;
@property (weak, nonatomic) IBOutlet UIImageView *imgCarsCount;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *lblFrom;
@property (weak, nonatomic) IBOutlet MPGTextField *txtFromName;
@property (strong, nonatomic) IBOutlet UIButton *btnLocationFrom;

@property (weak, nonatomic) IBOutlet UILabel *lblTo;
@property (weak, nonatomic) IBOutlet MPGTextField *txtToName;
@property (strong, nonatomic) IBOutlet UIButton *btnLocationTo;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnRefresh;

@property (weak, nonatomic) IBOutlet UIButton *btn1seat;
@property (weak, nonatomic) IBOutlet UIButton *btn2seat;
@property (weak, nonatomic) IBOutlet UIButton *btn3seat;
@property (weak, nonatomic) IBOutlet UILabel *bgFrom;
@property (weak, nonatomic) IBOutlet UILabel *bgTo;

- (IBAction)onFromLocation:(id)sender;
- (IBAction)onToLocation:(id)sender;

- (IBAction)onSelectSeat:(id)sender;
- (IBAction)onRefresh:(id)sender;

@end
