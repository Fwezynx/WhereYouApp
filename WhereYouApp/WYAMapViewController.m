//
//  WYAMapViewController.m
//  WhereYouApp
//
//  Created by Timothy Chu on 2/26/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAMapViewController.h"

@interface WYAMapViewController ()

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
    [super viewDidLoad];
    _mapView.showsUserLocation = YES;
    [_notifications setEnabled:NO];
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager startUpdatingLocation];

    NSMutableArray *userArray = [[NSMutableArray alloc] init];
    
    //-----------------------------------------------------------------------
    
    CLLocationDistance alt = _locationManager.location.altitude;
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude +  1, _locationManager.location.coordinate.longitude);
    WYAUserAnnotation *user = [[WYAUserAnnotation alloc] initWithUserName:@"These Aren't The Droids You're looking For" andCoordinate:coords andAltitude:alt];
    [userArray addObject:user];
    
    alt = _locationManager.location.altitude - 10;
    coords = CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude - 1, _locationManager.location.coordinate.longitude - 1);
    user = [[WYAUserAnnotation alloc] initWithUserName:@"IT'S A TRAP!" andCoordinate:coords andAltitude:alt];
    [userArray addObject:user];
    
    alt = _locationManager.location.altitude + 10;
    coords = CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude + 1, _locationManager.location.coordinate.longitude + 1);
    user = [[WYAUserAnnotation alloc] initWithUserName:@"The Cake Is A Lie" andCoordinate:coords andAltitude:alt];
    [userArray addObject:user];
    
    alt = _locationManager.location.altitude;
    coords = CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude - 1, _locationManager.location.coordinate.longitude + 1);
    user = [[WYAUserAnnotation alloc] initWithUserName:@"They're Taking The Hobbits To Isengard!" andCoordinate:coords andAltitude:alt];
    [userArray addObject:user];
    
    alt = _locationManager.location.altitude - 10;
    coords = CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude + 1, _locationManager.location.coordinate.longitude - 1);
    user = [[WYAUserAnnotation alloc] initWithUserName:@"Tell Me Where Is Gandalf, For I Much Desire To Speak With Him" andCoordinate:coords andAltitude:alt];
    [userArray addObject:user];
    //-----------------------------------------------------------------------
    
    [_mapView addAnnotations:userArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
