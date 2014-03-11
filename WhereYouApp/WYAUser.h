//
//  WYAUser.h
//  WhereYouApp
//
//  Created by Timothy Chu on 3/9/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WYAUser : NSObject

+ (WYAUser *) getInstance;
- (void) setUsername:(NSString *)username;
- (NSString *) getUsername;
- (CLLocationManager *) getLocationManager;
- (NSMutableArray *) getFriendList;
- (NSMutableArray *) getGroupsList;

@end
