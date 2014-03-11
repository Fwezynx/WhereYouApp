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
#import "WYAUser.h"

@interface WYAMapViewController : UIViewController<MKMapViewDelegate>

-(IBAction)returnToUser:(id)sender;
-(int)calculateDistance:(CLLocation *)userLocation;

@end
