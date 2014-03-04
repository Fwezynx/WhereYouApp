//
//  WYAUserAnnotation.h
//  WhereYouApp
//
//  Created by Timothy Chu on 3/1/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WYAUserAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property CLLocationDistance altitude;

- (id) initWithUserName:(NSString *)user andCoordinate:(CLLocationCoordinate2D)coords andAltitude:(CLLocationDistance)alt;

- (void) moveUserToCoordinate:(CLLocationCoordinate2D)coords withAltitude:(CLLocationDistance)alt;

@end
