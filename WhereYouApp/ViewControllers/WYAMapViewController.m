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
@property IBOutlet UILabel *height;
@property IBOutlet UILabel *updateTime;
@property IBOutlet UIView *userInfoView;

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
    [_userInfoView setHidden:YES];
    [_currentUser.locationManager.location addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    // Add any new annotations.
    [_mapView addAnnotations:[_currentUser.userAnnotations allValues]];
    // Enable or disable notifications.
    if ([_currentUser.friendRequestList count] != 0 || [_currentUser.groupRequestList count] != 0) {
        [_notifications setEnabled:YES];
    }
    else {
        [_notifications setEnabled:NO];
    }
}

// Center map around user and zoom.
- (IBAction) returnToUser:(id)sender
{
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
- (int)calculateDistance:(CLLocation *)userLocation
{
    double distance;
    distance = [_currentUser.locationManager.location distanceFromLocation:userLocation];
    // Convert distance from meters to feet.
    distance *= 3.2808399;
    return (int)distance;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    // Don't calculate distance for current user.
    if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
        return;
    }
    WYAUserAnnotation *userAnnotation = (WYAUserAnnotation *)view.annotation;
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:userAnnotation.coordinate altitude:userAnnotation.altitude horizontalAccuracy:_currentUser.locationManager.location.horizontalAccuracy verticalAccuracy:_currentUser.locationManager.location.verticalAccuracy timestamp:[NSDate date]];
    [userAnnotation setSubtitle:[NSString stringWithFormat:@"%d feet",[self calculateDistance:location]]];
    // Display additional user information
    [_userInfoView setHidden:NO];
    int heightDifference = userAnnotation.altitude - _currentUser.locationManager.location.altitude;
    NSString *heightPlacement = @"above";
    if (heightDifference < 0) {
        heightDifference = - heightDifference;
        heightPlacement = @"below";
    }
    [_height setText:[NSString stringWithFormat:@"%d feet %@",heightDifference, heightPlacement]];
    NSInteger timeDifference = [userAnnotation.updateTime timeIntervalSinceNow];
    NSString *timeUnits = @"seconds";
    if (timeDifference >= 60) {
        timeDifference /= 60;
        timeUnits = @"minutes";
        if (timeDifference >= 60) {
            timeDifference /= 60;
            timeUnits = @"hours";
            if (timeDifference >= 24) {
                timeDifference /= 24;
                timeUnits = @"days";
            }
        }
    }
    [_updateTime setText:[NSString stringWithFormat:@"%ld %@ ago",(long)timeDifference, timeUnits]];
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    // Hide user details.
    [_userInfoView setHidden:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
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

- (IBAction)didPressSignout:(id)sender
{
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
