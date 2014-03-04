//
//  WYAMapViewController.h
//  WhereYouApp
//
//  Created by Timothy Chu on 2/26/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WYAUserAnnotation.h"

@interface WYAMapViewController : UIViewController<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property IBOutlet UIBarButtonItem *notifications;
@property CLLocationManager *locationManager;

@end
