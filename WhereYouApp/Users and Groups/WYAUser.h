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

+ (WYAUser *) sharedInstance;

@property NSString *username;
@property CLLocationManager *locationManager;
@property NSMutableArray *friendList;
@property NSMutableArray *groupsList;
@property NSMutableArray *blockedFriendsList;
@property NSMutableArray *friendRequestList;
@property NSMutableArray *groupRequestList;

@end
