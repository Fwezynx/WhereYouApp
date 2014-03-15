//
//  WYAUser.m
//  WhereYouApp
//
//  Created by Timothy Chu on 3/9/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAUser.h"

@implementation WYAUser

// Return singleton.
+ (WYAUser *) sharedInstance {
    static WYAUser *sharedInstance = nil;
    // Initialize the object if it doesn't exist yet.
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

+ (id) allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id) init {
    self = [super init];
    _username = [[NSString alloc] init];
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager startUpdatingLocation];
    _friendList = [[NSMutableArray alloc] init];
    _groupsList = [[NSMutableArray alloc] init];
    _blockedFriendsList = [[NSMutableArray alloc] init];
    _groupRequestList = [[NSMutableArray alloc] init];
    _friendRequestList = [[NSMutableArray alloc] init];
    return self;
}

@end
