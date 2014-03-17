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
+(instancetype)sharedInstance
{
    static WYAUser *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WYAUser alloc] init];
    });
    return sharedInstance;
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
