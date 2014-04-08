//
//  WYAUser.h
//  WhereYouApp
//
//  Created by Timothy Chu on 3/9/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <AWSDynamoDB/AWSDynamoDB.h>

#define ACCESS_KEY_ID @"AKIAIIU6MJGNDKQVNQAQ"
#define SECRET_ACCESS_KEY @"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"

@interface WYAUser : NSObject<CLLocationManagerDelegate>

+ (WYAUser *) sharedInstance;

@property NSString *username;
@property CLLocationManager *locationManager;
@property NSMutableArray *friendList;
@property NSMutableArray *groupsList;
@property NSMutableArray *blockedFriendsList;
@property NSMutableArray *friendRequestList;
@property NSMutableArray *groupRequestList;
@property NSMutableArray *invitedFriendsList;
@property NSMutableArray *blockedByUsersList;
@property AmazonDynamoDBClient *dynamoDBClient;

- (BOOL) userExists:(NSString *)username;
- (BOOL) createUser:(NSString *)username withPassword:(NSString *)password email:(NSString *)email question:(NSString *)question answer:(NSString *)answer;
- (BOOL) userLogin:(NSString *)username withPassword:(NSString *)password;

@end
