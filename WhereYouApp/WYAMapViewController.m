//
//  WYAMapViewController.m
//  WhereYouApp
//
//  Created by Timothy Chu on 2/26/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAMapViewController.h"

@interface WYAMapViewController ()

@property NSMutableArray *userArray;
@property IBOutlet UIBarButtonItem *notifications;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;
@property WYAUser *currentUser;

@end

@implementation WYAMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    // Show user location, update location, and center map on user.
    [super viewDidLoad];
    _mapView.showsUserLocation = YES;
    _currentUser = [WYAUser getInstance];
    [_notifications setEnabled:YES];
    _locationManager = [_currentUser getLocationManager];
    [self returnToUser:self];
    
    // Store users to place annotations.  Move to WYAUser?
    _userArray = [[NSMutableArray alloc] init];
    
    //----------------------------------------------------------------------- TEMPORARY FOR EXAMPLES
    
    CLLocationDistance alt = _locationManager.location.altitude;
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude +  0.1/69.0, _locationManager.location.coordinate.longitude);

    WYAUserAnnotation *user = [[WYAUserAnnotation alloc] initWithLocation:coords title:@"These Aren't The Droids You're Looking For" andSubtitle:[NSString stringWithFormat:@"%f\n%f", coords.latitude, coords.longitude]];
    [user setAltitude:_locationManager.location.altitude];
    [_userArray addObject:user];
    
    alt = _locationManager.location.altitude - 10;
    coords = CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude - 0.1/69.0, _locationManager.location.coordinate.longitude - 0.1/69.0);
    user = [[WYAUserAnnotation alloc] initWithUserName:@"IT'S A TRAP!" andCoordinate:coords andAltitude:alt];
    [_userArray addObject:user];
    
    alt = _locationManager.location.altitude + 10;
    coords = CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude + 0.2/69.0, _locationManager.location.coordinate.longitude + 0.2/69.0);
    user = [[WYAUserAnnotation alloc] initWithUserName:@"The Cake Is A Lie" andCoordinate:coords andAltitude:alt];
    [_userArray addObject:user];
    
    alt = _locationManager.location.altitude;
    coords = CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude - 0.3/69.0, _locationManager.location.coordinate.longitude + 0.3/69.0);
    user = [[WYAUserAnnotation alloc] initWithUserName:@"They're Taking The Hobbits To Isengard!" andCoordinate:coords andAltitude:alt];
    [_userArray addObject:user];
    alt = _locationManager.location.altitude - 10;
    coords = CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude + 0.25/69.0, _locationManager.location.coordinate.longitude - 0.1/69.0);
    user = [[WYAUserAnnotation alloc] initWithUserName:@"Tell Me Where Is Gandalf, For I Much Desire To Speak With Him" andCoordinate:coords andAltitude:alt];
    [_userArray addObject:user];
    //-----------------------------------------------------------------------
    
    [_mapView addAnnotations:_userArray];
}

// Center map around user and zoom.
- (IBAction)returnToUser:(id)sender {
    double miles = 1;
    double scalingFactor = ABS((cos(2*M_PI*_locationManager.location.coordinate.latitude/360)));
    MKCoordinateSpan span;
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/(scalingFactor*69.0);
    MKCoordinateRegion region;
    region.span = span;
    region.center = _locationManager.location.coordinate;
    [_mapView setRegion:region animated:YES];
}

// Obtain distance in feet from current user to selected user
- (int)calculateDistance:(CLLocation *)userLocation {
    double distance;
    distance = [_locationManager.location distanceFromLocation:userLocation];
    // Convert distance from meters to feet.
    distance *= 3.2808399;
    return (int)distance;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    WYAUserAnnotation *userAnnotation = (WYAUserAnnotation *)view.annotation;
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:userAnnotation.coordinate altitude:userAnnotation.altitude horizontalAccuracy:_locationManager.location.horizontalAccuracy verticalAccuracy:_locationManager.location.verticalAccuracy timestamp:[NSDate date]];
    [self calculateDistance:location];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // Try to dequeue pin annotation view first.
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ViewIdentifier"];
    if (pinView == NULL) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:(WYAUserAnnotation *)annotation reuseIdentifier:@"ViewIdentifier"];
    }
    pinView.canShowCallout = YES;
    pinView.pinColor = MKPinAnnotationColorGreen;
    return pinView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
