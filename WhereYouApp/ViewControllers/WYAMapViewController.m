//
//  WYAMapViewController.m
//  WhereYouApp
//
//  Created by Timothy Chu on 2/26/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAMapViewController.h"

@interface WYAMapViewController ()

@property IBOutlet UIBarButtonItem *notifications;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property WYAUser *currentUser;

@end

@implementation WYAMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    // Show user location, update location, and center map on user.
    [super viewDidLoad];
    [_mapView setDelegate:self];
    [_mapView setShowsUserLocation:YES];
    _currentUser = [WYAUser sharedInstance];
    [self returnToUser:self];
    
#warning TEMPORARY FOR EXAMPLES
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    CLLocationDistance alt = _currentUser.locationManager.location.altitude;
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(_currentUser.locationManager.location.coordinate.latitude +  0.1/69.0, _currentUser.locationManager.location.coordinate.longitude);

    WYAUserAnnotation *user = [[WYAUserAnnotation alloc] initWithUserName:@"These Aren't The Droids You're Looking For" andCoordinate:coords andAltitude:alt];
    [user setStatus:1];
    [_currentUser.friendList addObject:user];
    
    alt = _currentUser.locationManager.location.altitude - 10;
    coords = CLLocationCoordinate2DMake(_currentUser.locationManager.location.coordinate.latitude - 0.1/69.0, _currentUser.locationManager.location.coordinate.longitude - 0.1/69.0);
    user = [[WYAUserAnnotation alloc] initWithUserName:@"IT'S A TRAP!" andCoordinate:coords andAltitude:alt];
    [user setStatus:1];
    [_currentUser.friendList addObject:user];
    
    alt = _currentUser.locationManager.location.altitude + 10;
    coords = CLLocationCoordinate2DMake(_currentUser.locationManager.location.coordinate.latitude + 0.2/69.0, _currentUser.locationManager.location.coordinate.longitude + 0.2/69.0);
    user = [[WYAUserAnnotation alloc] initWithUserName:@"The Cake Is A Lie" andCoordinate:coords andAltitude:alt];
    [user setStatus:1];
    [_currentUser.friendList addObject:user];
    
    alt = _currentUser.locationManager.location.altitude;
    coords = CLLocationCoordinate2DMake(_currentUser.locationManager.location.coordinate.latitude - 0.3/69.0, _currentUser.locationManager.location.coordinate.longitude + 0.3/69.0);
    user = [[WYAUserAnnotation alloc] initWithUserName:@"They're Taking The Hobbits To Isengard!" andCoordinate:coords andAltitude:alt];
    [user setStatus:1];
    [_currentUser.friendList addObject:user];
    alt = _currentUser.locationManager.location.altitude - 10;
    coords = CLLocationCoordinate2DMake(_currentUser.locationManager.location.coordinate.latitude + 0.25/69.0, _currentUser.locationManager.location.coordinate.longitude - 0.1/69.0);
    user = [[WYAUserAnnotation alloc] initWithUserName:@"Tell Me Where Is Gandalf, For I Much Desire To Speak With Him" andCoordinate:coords andAltitude:alt];
    [user setStatus:1];
    [_currentUser.friendList addObject:user];
    });
}

- (void) viewDidAppear:(BOOL)animated {
    // Add any new annotations.
    [_mapView addAnnotations:_currentUser.friendList];
    // Enable or disable notifications.
    if ([_currentUser.friendRequestList count] != 0 || [_currentUser.groupRequestList count] != 0) {
        [_notifications setEnabled:YES];
    }
    else {
        [_notifications setEnabled:NO];
    }
}

// Center map around user and zoom.
- (IBAction)returnToUser:(id)sender {
    double miles = 1;
    double scalingFactor = ABS((cos(2*M_PI*_currentUser.locationManager.location.coordinate.latitude/360)));
    MKCoordinateSpan span;
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/(scalingFactor*69.0);
    MKCoordinateRegion region;
    region.span = span;
    region.center = _currentUser.locationManager.location.coordinate;
    [_mapView setRegion:region animated:YES];
}

// Obtain distance in feet from current user to selected user
- (int)calculateDistance:(CLLocation *)userLocation {
    double distance;
    distance = [_currentUser.locationManager.location distanceFromLocation:userLocation];
    // Convert distance from meters to feet.
    distance *= 3.2808399;
    return (int)distance;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    // Don't calculate distance for current user.
    if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
        return;
    }
    WYAUserAnnotation *userAnnotation = (WYAUserAnnotation *)view.annotation;
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:userAnnotation.coordinate altitude:userAnnotation.altitude horizontalAccuracy:_currentUser.locationManager.location.horizontalAccuracy verticalAccuracy:_currentUser.locationManager.location.verticalAccuracy timestamp:[NSDate date]];
    [userAnnotation setSubtitle:[NSString stringWithFormat:@"%d feet",[self calculateDistance:location]]];
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // Don't use custom annotation view for current user.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    // Try to dequeue pin annotation view first.
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ViewIdentifier"];
    if (pinView == NULL) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:(WYAUserAnnotation *)annotation reuseIdentifier:@"ViewIdentifier"];
    }
    pinView.canShowCallout = YES;
    pinView.pinColor = MKPinAnnotationColorGreen;
    return pinView;
}

- (IBAction)didPressSignout:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *newView = [mainStoryboard instantiateViewControllerWithIdentifier:@"login"];
    [self.navigationController setViewControllers:[[NSArray alloc] initWithObjects:newView, nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
