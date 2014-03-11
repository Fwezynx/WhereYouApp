//
//  WYAUser.m
//  WhereYouApp
//
//  Created by Timothy Chu on 3/9/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAUser.h"

@implementation WYAUser

static WYAUser *userInstance = nil;
static NSString *userName = nil;
static CLLocationManager *locationManager = nil;
static NSMutableArray *friendList = nil;
static NSMutableArray *groupsList = nil;

// Return singleton.
+ (WYAUser *) getInstance {
    if (userInstance == nil) {
        userInstance = [[WYAUser alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        [locationManager startUpdatingLocation];
        friendList = [[NSMutableArray alloc] init];
        groupsList = [[NSMutableArray alloc] init];
    }
    return userInstance;
}

- (void) setUsername:(NSString *)username {
    userName = username;
}

- (NSString *) getUsername {
    return userName;
}

- (CLLocationManager *) getLocationManager {
    return locationManager;
}

- (NSMutableArray *) getFriendList {
    return friendList;
}

- (NSMutableArray *) getGroupsList {
    return groupsList;
}

@end
