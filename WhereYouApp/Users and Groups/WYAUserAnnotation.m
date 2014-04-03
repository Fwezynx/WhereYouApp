//
//  WYAUserAnnotation.m
//  WhereYouApp
//
//  Created by Timothy Chu on 3/1/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAUserAnnotation.h"

@implementation WYAUserAnnotation

- (id) initWithUserName:(NSString *)user andCoordinate:(CLLocationCoordinate2D)coords andAltitude:(CLLocationDistance)alt
{
    self = [super init];
    [self setAltitude:alt];
    [self setCoordinate:coords];
    _title = user;
    _subtitle = [NSString stringWithFormat:@"Longitude: %f, Latitude: %f, Altitude: %f", coords.longitude, coords.latitude, alt];
    return self;
}

// Update user latitude, longitude, altitude, and updateTime.
- (void) updateUser
{

}

@end
