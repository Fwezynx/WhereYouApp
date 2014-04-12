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
    [self updateLocation];
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

// Update user location in database.
- (void) updateLocation {
    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
    
    DynamoDBAttributeValue *value = [[DynamoDBAttributeValue alloc] initWithN:[NSString stringWithFormat:@"%f",_locationManager.location.coordinate.latitude]];
    DynamoDBAttributeValueUpdate *updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"PUT"];
    NSString *key = @"latitude";
    [item setValue:updateValue forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithN:[NSString stringWithFormat:@"%f",_locationManager.location.coordinate.longitude]];
    updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"PUT"];
    key = @"longitude";
    [item setValue:updateValue forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithN:[NSString stringWithFormat:@"%f",_locationManager.location.altitude]];
    updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"PUT"];
    key = @"altitude";
    [item setValue:updateValue forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithS:[NSString stringWithFormat:@"%@",[NSDate date]]];
    updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"PUT"];
    key = @"lastUpdated";
    [item setValue:updateValue forKey:key];
    
    // Construct request
    value = [[DynamoDBAttributeValue alloc] initWithS: [_username lowercaseString]];
    DynamoDBUpdateItemRequest *updateRequest = [[DynamoDBUpdateItemRequest alloc] initWithTableName:@"WhereYouApp" andKey:[[NSMutableDictionary alloc] initWithObjectsAndKeys:value ,@"username",nil] andAttributeUpdates:item];
    [_dynamoDBClient updateItem:updateRequest];
}

// Create a user
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
    [_dynamoDBClient putItem:putRequest];
    return YES;
}

// Obtain user credentials for logging in.
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
        _username = username;
        value = [getResponse.item objectForKey:@"friends"];
        [_friendList addObjectsFromArray:value.sS];
        value = [getResponse.item objectForKey:@"friendRequests"];
        [_friendRequestList addObjectsFromArray:value.sS];
        value = [getResponse.item objectForKey:@"invitedFriends"];
        [_invitedFriendsList addObjectsFromArray:value.sS];
        value = [getResponse.item objectForKey:@"blockedUsers"];
        [_blockedFriendsList addObjectsFromArray:value.sS];
        value = [getResponse.item objectForKey:@"blockedByUsers"];
        [_blockedByUsersList addObjectsFromArray:value.sS];
        // Get group names
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        NSMutableArray *groupRequests = [[NSMutableArray alloc] init];
        value = [getResponse.item objectForKey:@"groups"];
        groups = value.nS;
        value = [getResponse.item objectForKey:@"groupRequests"];
        groupRequests = value.nS;
        for (NSString *groupID in groups) {
            item = [[NSMutableDictionary alloc] initWithObjectsAndKeys:groupID,@"groupID",nil];
            getRequest = [[DynamoDBGetItemRequest alloc] initWithTableName:@"WhereYouAppGroups" andKey:item];
            getResponse = [_dynamoDBClient getItem:getRequest];
            value = [getResponse.item objectForKey:@"groupName"];
            WYAGroups *group = [[WYAGroups alloc] init];
            [group setGroupID:groupID];
            [group setGroupName:value.s];
            value = [getResponse.item objectForKey:@"groupMembers"];
            [group setGroupMembers:value.sS];
            [_groupsList addObject:group];
        }
        for (NSString *groupID in groupRequests) {
            item = [[NSMutableDictionary alloc] initWithObjectsAndKeys:groupID,@"groupID",nil];
            getRequest = [[DynamoDBGetItemRequest alloc] initWithTableName:@"WhereYouAppGroups" andKey:item];
            getResponse = [_dynamoDBClient getItem:getRequest];
            value = [getResponse.item objectForKey:@"groupName"];
            WYAGroups *group = [[WYAGroups alloc] init];
            [group setGroupID:groupID];
            [group setGroupName:value.s];
            [_groupRequestList addObject:group];
        }
        [self updateLocation];
        return YES;
    }
    return NO;
}

// Invite a user to become friends
- (void) inviteFriend:(NSString *)friendName {
    // Add friend to current user's invited list
    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
    DynamoDBAttributeValue *value = [[DynamoDBAttributeValue alloc] initWithSS:[[NSMutableArray alloc] initWithObjects:[friendName lowercaseString],nil]];
    DynamoDBAttributeValueUpdate *updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"ADD"];
    NSString *key = @"invitedFriends";
    [item setValue:updateValue forKey:key];
    value = [[DynamoDBAttributeValue alloc] initWithS: [_username lowercaseString]];
    DynamoDBUpdateItemRequest *updateRequest = [[DynamoDBUpdateItemRequest alloc] initWithTableName:@"WhereYouApp" andKey:[[NSMutableDictionary alloc] initWithObjectsAndKeys:value ,@"username",nil] andAttributeUpdates:item];
    [_dynamoDBClient updateItem:updateRequest];
    // Add current user to friend's friendRequest list
    [item removeAllObjects];
    
    value = [[DynamoDBAttributeValue alloc] initWithSS:[[NSMutableArray alloc] initWithObjects:[_username lowercaseString],nil]];
    key = @"friendRequests";
    updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"ADD"];
    [item setValue:updateValue forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithS:[friendName lowercaseString]];
    updateRequest = [[DynamoDBUpdateItemRequest alloc] initWithTableName:@"WhereYouApp" andKey:[[NSMutableDictionary alloc] initWithObjectsAndKeys:value ,@"username",nil] andAttributeUpdates:item];
    [_dynamoDBClient updateItem:updateRequest];
    // Add item to local copy of current user's invited friends list.
    [_invitedFriendsList addObject:[friendName lowercaseString]];
}

// Remove a user from blocked list.
- (void) unblockUser:(NSString *)friendName {
    // Remove user from current user's blocked list
    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
    DynamoDBAttributeValue *value = [[DynamoDBAttributeValue alloc] initWithSS:[[NSMutableArray alloc] initWithObjects:[friendName lowercaseString],nil]];
    DynamoDBAttributeValueUpdate *updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"DELETE"];
    NSString *key = @"blockedUsers";
    [item setValue:updateValue forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithS: [_username lowercaseString]];
    DynamoDBUpdateItemRequest *updateRequest = [[DynamoDBUpdateItemRequest alloc] initWithTableName:@"WhereYouApp" andKey:[[NSMutableDictionary alloc] initWithObjectsAndKeys:value ,@"username",nil] andAttributeUpdates:item];
    [_dynamoDBClient updateItem:updateRequest];
    // Remove current user from user's blocked by list
    [item removeAllObjects];
    
    value = [[DynamoDBAttributeValue alloc] initWithSS:[[NSMutableArray alloc] initWithObjects:[_username lowercaseString],nil]];
    key = @"blockedByUsers";
    updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"DELETE"];
    [item setValue:updateValue forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithS:[friendName lowercaseString]];
    updateRequest = [[DynamoDBUpdateItemRequest alloc] initWithTableName:@"WhereYouApp" andKey:[[NSMutableDictionary alloc] initWithObjectsAndKeys:value ,@"username",nil] andAttributeUpdates:item];
    [_dynamoDBClient updateItem:updateRequest];
    // Add item to local copy of current user's invited friends list.
    [_blockedFriendsList removeObject:[friendName lowercaseString]];
}

// Accept an invitation to become friends
- (void) acceptFriendRequest:(NSString *)friendName {
    // Add friend to current user's friend list and remove from invited list.
    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
    DynamoDBAttributeValue *value = [[DynamoDBAttributeValue alloc] initWithSS:[[NSMutableArray alloc] initWithObjects:[friendName lowercaseString],nil]];
    DynamoDBAttributeValueUpdate *updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"ADD"];
    NSString *key = @"friends";
    [item setValue:updateValue forKey:key];
    
    updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"DELETE"];
    key = @"friendRequests";
    [item setValue:updateValue forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithS: [_username lowercaseString]];
    DynamoDBUpdateItemRequest *updateRequest = [[DynamoDBUpdateItemRequest alloc] initWithTableName:@"WhereYouApp" andKey:[[NSMutableDictionary alloc] initWithObjectsAndKeys:value ,@"username",nil] andAttributeUpdates:item];
    [_dynamoDBClient updateItem:updateRequest];
    // Add current user to friend's friend list and remove from pending friends list.
    [item removeAllObjects];
    
    value = [[DynamoDBAttributeValue alloc] initWithSS:[[NSMutableArray alloc] initWithObjects:[_username lowercaseString],nil]];
    key = @"friends";
    updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"ADD"];
    [item setValue:updateValue forKey:key];
    
    updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"DELETE"];
    key = @"invitedFriends";
    [item setValue:updateValue forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithS:[friendName lowercaseString]];
    updateRequest = [[DynamoDBUpdateItemRequest alloc] initWithTableName:@"WhereYouApp" andKey:[[NSMutableDictionary alloc] initWithObjectsAndKeys:value ,@"username",nil] andAttributeUpdates:item];
    [_dynamoDBClient updateItem:updateRequest];
    // Add item to local copy of current user's invited friends list.
    [_friendRequestList removeObject:[friendName lowercaseString]];
    [_friendList addObject:[friendName lowercaseString]];
}

@end
