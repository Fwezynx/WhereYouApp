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
#import "WYAGroups.h"
#import "WYAUserAnnotation.h"

#define ACCESS_KEY_ID @"AKIAJMXIHSTRUQOJSTGA"

#define SECRET_ACCESS_KEY @"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"



@interface WYAUser : NSObject<CLLocationManagerDelegate>

+ (WYAUser *) sharedInstance;

@property NSString *username;
@property CLLocationManager *locationManager;
@property NSMutableArray *friendList;
@property NSMutableDictionary *groupsList;
@property NSMutableArray *blockedFriendsList;
@property NSMutableArray *friendRequestList;
@property NSMutableDictionary *groupRequestList;
@property NSMutableArray *invitedFriendsList;
@property NSMutableArray *blockedByUsersList;
@property AmazonDynamoDBClient *dynamoDBClient;

- (BOOL) userExists:(NSString *)username;
- (BOOL) createUser:(NSString *)username withPassword:(NSString *)password email:(NSString *)email question:(NSString *)question answer:(NSString *)answer;
- (BOOL) userLogin:(NSString *)username withPassword:(NSString *)password;
- (void) updateLocation;
- (void) inviteFriend:(NSString *)friendName;
- (void) unblockUser:(NSString *)friendName;
- (void) acceptFriendRequest:(NSString *)friendName;
- (void) removeUser:(NSString *)username;
- (NSString *) createGroup:(NSString *)groupName;
- (void) inviteUser:(NSString *)username toGroup:(NSString *)groupID;
- (void) leaveGroup:(NSString *)groupID;
- (void) acceptGroupInvite:(NSString *)groupID;
- (void) ignoreGroupInvite:(NSString *)groupID;
- (void) ignoreUser:(NSString *)username;
- (void) blockUser:(NSString *)username;

@end
