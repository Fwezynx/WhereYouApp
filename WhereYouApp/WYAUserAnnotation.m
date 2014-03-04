//
//  WYAUserAnnotation.m
//  WhereYouApp
//
//  Created by Timothy Chu on 3/1/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAUserAnnotation.h"

@implementation WYAUserAnnotation

-(id) initWithUserName:(NSString *)user andCoordinate:(CLLocationCoordinate2D)coords andAltitude:(CLLocationDistance)alt {
    self = [super init];
    _title = user;
    _subtitle = [NSString stringWithFormat:@"Longitude: %f, Latitude: %f, Altitude: %f", coords.longitude, coords.latitude, alt];
    _coordinate = coords;
    _altitude = alt;
    return self;
}

-(void) moveUserToCoordinate:(CLLocationCoordinate2D)coords withAltitude:(CLLocationDistance)alt {
    _coordinate = coords;
    _altitude = alt;
}

@end
