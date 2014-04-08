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

- (id) init
{
    self = [super init];
    _username = [[NSString alloc] init];
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingHeading];
    _friendList = [[NSMutableArray alloc] init];
    _groupsList = [[NSMutableArray alloc] init];
    _blockedFriendsList = [[NSMutableArray alloc] init];
    _groupRequestList = [[NSMutableArray alloc] init];
    _friendRequestList = [[NSMutableArray alloc] init];
    _invitedFriendsList = [[NSMutableArray alloc] init];
    _blockedByUsersList = [[NSMutableArray alloc] init];
    AmazonCredentials *credentials = [[AmazonCredentials alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_ACCESS_KEY];
    _dynamoDBClient = [[AmazonDynamoDBClient alloc] initWithCredentials:credentials];
    return self;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
#warning update location for user
}

- (BOOL) userExists:(NSString *)username {
    // Create attributes for request
    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
    
    DynamoDBAttributeValue *value = [[DynamoDBAttributeValue alloc] initWithS:username];
    NSString *key = @"username";
    [item setValue:value forKey:key];
    
    DynamoDBGetItemRequest *getRequest = [[DynamoDBGetItemRequest alloc] initWithTableName:@"WhereYouApp" andKey:item];
    [getRequest setAttributesToGet: [[NSMutableArray alloc] initWithObjects:@"username",nil]];
    DynamoDBGetItemResponse *getResponse = [_dynamoDBClient getItem:getRequest];
    if (getResponse.item.count == 0) {
        return NO;
    }
    return YES;
}

- (BOOL) createUser:(NSString *)username withPassword:(NSString *)password email:(NSString *)email question:(NSString *)question answer:(NSString *)answer {
    // Create attributes for request
    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
    
    DynamoDBAttributeValue *value = [[DynamoDBAttributeValue alloc] initWithS:username];
    NSString *key = @"username";
    [item setValue:value forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithS:password];
    key = @"password";
    [item setValue:value forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithS:email];
    key = @"email";
    [item setValue:value forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithS:question];
    key = @"question";
    [item setValue:value forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithS:answer];
    key = @"answer";
    [item setValue:value forKey:key];
    
    // Construct request
    DynamoDBPutItemRequest *putRequest = [[DynamoDBPutItemRequest alloc] initWithTableName:@"WhereYouApp" andItem:item];
    DynamoDBPutItemResponse *putResponse = [_dynamoDBClient putItem:putRequest];
    return YES;
}

- (BOOL) userLogin:(NSString *)username withPassword:(NSString *)password {
    // Create attributes for request
    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
    
    DynamoDBAttributeValue *value = [[DynamoDBAttributeValue alloc] initWithS:username];
    NSString *key = @"username";
    [item setValue:value forKey:key];
    
    DynamoDBGetItemRequest *getRequest = [[DynamoDBGetItemRequest alloc] initWithTableName:@"WhereYouApp" andKey:item];
    [getRequest setAttributesToGet: [[NSMutableArray alloc] initWithObjects:@"password", @"friends", @"friendRequests", @"invitedFriends", @"blockedUsers", @"blockedByUsers", @"groups", @"groupRequests", nil]];
    DynamoDBGetItemResponse *getResponse = [_dynamoDBClient getItem:getRequest];
    value = [getResponse.item objectForKey:@"password"];
    if ([password isEqualToString:value.s]) {
        value = [getResponse.item objectForKey:@"friends"];
        _friendList = value.sS;
        value = [getResponse.item objectForKey:@"friendRequests"];
        _friendRequestList = value.sS;
        value = [getResponse.item objectForKey:@"invitedFriends"];
        _invitedFriendsList = value.sS;
        value = [getResponse.item objectForKey:@"blockedUsers"];
        _blockedFriendsList = value.sS;
        value = [getResponse.item objectForKey:@"blockedByUsers"];
        _blockedByUsersList = value.sS;
        value = [getResponse.item objectForKey:@"groups"];
        _groupsList = value.nS;
        value = [getResponse.item objectForKey:@"groupRequests"];
        _groupRequestList = value.nS;
        return YES;
    }
    return NO;
}

@end
