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
    _groupsList = [[NSMutableDictionary alloc] init];
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
    
    value = [[DynamoDBAttributeValue alloc] initWithN:[NSString stringWithFormat:@"%f",_locationManager.location.coordinate.latitude]];
    key = @"latitude";
    [item setValue:value forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithN:[NSString stringWithFormat:@"%f",_locationManager.location.coordinate.longitude]];
    key = @"longitude";
    [item setValue:value forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithN:[NSString stringWithFormat:@"%f",_locationManager.location.altitude]];
    key = @"altitude";
    [item setValue:value forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithS:[NSString stringWithFormat:@"%@",[NSDate date]]];
    key = @"lastUpdated";
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
#warning optimize with dynamodbcondition query search?
        for (NSString *groupID in groups) {
            item = [[NSMutableDictionary alloc] initWithObjectsAndKeys:groupID,@"groupID",nil];
            getRequest = [[DynamoDBGetItemRequest alloc] initWithTableName:@"WhereYouAppGroups" andKey:item];
            getResponse = [_dynamoDBClient getItem:getRequest];
            value = [getResponse.item objectForKey:@"groupName"];
            WYAGroups *group = [[WYAGroups alloc] init];
            [group setGroupID:groupID];
            [group setGroupName:value.s];
            value = [getResponse.item objectForKey:@"members"];
            [group setGroupMemberNames:value.sS];
            // Get member info
            for (NSString *groupMember in value.sS) {
                NSMutableDictionary *useritem = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
                
                DynamoDBAttributeValue *uservalue = [[DynamoDBAttributeValue alloc] initWithS:groupMember];
                NSString *userkey = @"username";
                [useritem setValue:uservalue forKey:userkey];
                
                DynamoDBGetItemRequest *getUserRequest = [[DynamoDBGetItemRequest alloc] initWithTableName:@"WhereYouApp" andKey:useritem];
                [getUserRequest setAttributesToGet: [[NSMutableArray alloc] initWithObjects:@"latitude", @"longitude", @"altitudeuser", @"lastUpdated", nil]];
                DynamoDBGetItemResponse *getUserResponse = [_dynamoDBClient getItem:getUserRequest];
                value = [getUserResponse.item objectForKey:@"latitude"];
                double latitude = [value.n doubleValue];
                value = [getUserResponse.item objectForKey:@"longitude"];
                double longitude = [value.n doubleValue];
                value = [getUserResponse.item objectForKey:@"altitude"];
                double altitude = [value.n doubleValue];
                WYAUserAnnotation *user = [[WYAUserAnnotation alloc] initWithUserName:groupMember andCoordinate:CLLocationCoordinate2DMake(latitude, longitude) andAltitude:altitude];
                value = [getUserResponse.item objectForKey:@"lastUpdated"];
                NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
                NSDate *updateTime = [dateformat dateFromString:value.s];
                [user setUpdateTime:updateTime];
                [group.groupMembers setObject:user forKey:groupMember];
            }
            value = [getResponse.item objectForKey:@"invites"];
            [group setInvitedMembers:value.sS];
            [_groupsList setObject:group forKey:group.groupID];
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

- (void) removeUser:(NSString *)username {
    // Remove friend from user's friend list
    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
    DynamoDBAttributeValue *value = [[DynamoDBAttributeValue alloc] initWithSS:[[NSMutableArray alloc] initWithObjects:[username lowercaseString],nil]];
    DynamoDBAttributeValueUpdate *updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"DELETE"];
    NSString *key = @"friends";
    [item setValue:updateValue forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithS: [_username lowercaseString]];
    DynamoDBUpdateItemRequest *updateRequest = [[DynamoDBUpdateItemRequest alloc] initWithTableName:@"WhereYouApp" andKey:[[NSMutableDictionary alloc] initWithObjectsAndKeys:value ,@"username",nil] andAttributeUpdates:item];
    [_dynamoDBClient updateItem:updateRequest];
    
    // Remove user from friend's friend list
    [item removeAllObjects];
    value = [[DynamoDBAttributeValue alloc] initWithSS:[[NSMutableArray alloc] initWithObjects:[_username lowercaseString],nil]];
    updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"DELETE"];
    [item setValue:updateValue forKey:key];
    value = [[DynamoDBAttributeValue alloc] initWithS: [username lowercaseString]];
    updateRequest = [[DynamoDBUpdateItemRequest alloc] initWithTableName:@"WhereYouApp" andKey:[[NSMutableDictionary alloc] initWithObjectsAndKeys:value ,@"username",nil] andAttributeUpdates:item];
    [_dynamoDBClient updateItem:updateRequest];
}

- (void) createGroup:(NSString *)groupName {
    // Set groupID to be the current number of rows in the group
    NSString *groupID;
    // Create attributes for request
    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
    
    DynamoDBAttributeValue *value = [[DynamoDBAttributeValue alloc] initWithN:groupID];
    NSString *key = @"groupID";
    [item setValue:value forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithS:groupName];
    key = @"groupName";
    [item setValue:value forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithSS:[NSMutableArray arrayWithObject:_username]];
    key = @"members";
    [item setValue:value forKey:key];
    // Construct request
    DynamoDBPutItemRequest *putRequest = [[DynamoDBPutItemRequest alloc] initWithTableName:@"WhereYouAppGroups" andItem:item];
    [_dynamoDBClient putItem:putRequest];
}

- (void) inviteUser:(NSString *)username toGroup:(NSString *)groupID {
    // Add group to user's group invites.
    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
    DynamoDBAttributeValue *value = [[DynamoDBAttributeValue alloc] initWithNS:[[NSMutableArray alloc] initWithObjects:groupID,nil]];
    DynamoDBAttributeValueUpdate *updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"ADD"];
    NSString *key = @"groupRequests";
    [item setValue:updateValue forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithS: [username lowercaseString]];
    DynamoDBUpdateItemRequest *updateRequest = [[DynamoDBUpdateItemRequest alloc] initWithTableName:@"WhereYouApp" andKey:[[NSMutableDictionary alloc] initWithObjectsAndKeys:value ,@"username",nil] andAttributeUpdates:item];
    [_dynamoDBClient updateItem:updateRequest];
    
    // Add user to group's invite list.
    [item removeAllObjects];
    value = [[DynamoDBAttributeValue alloc] initWithSS:[[NSMutableArray alloc] initWithObjects:[username lowercaseString],nil]];
    updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"ADD"];
    key = @"invites";
    [item setValue:updateValue forKey:key];
    value = [[DynamoDBAttributeValue alloc] initWithN:groupID];
    updateRequest = [[DynamoDBUpdateItemRequest alloc] initWithTableName:@"WhereYouAppGroups" andKey:[[NSMutableDictionary alloc] initWithObjectsAndKeys:value ,@"groupID",nil] andAttributeUpdates:item];
    [_dynamoDBClient updateItem:updateRequest];
}

- (void) leaveGroup:(NSString *)groupID {
    // Remove group from user's list.
    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
    DynamoDBAttributeValue *value = [[DynamoDBAttributeValue alloc] initWithNS:[[NSMutableArray alloc] initWithObjects:groupID,nil]];
    DynamoDBAttributeValueUpdate *updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"DELETE"];
    NSString *key = @"groups";
    [item setValue:updateValue forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithS: [_username lowercaseString]];
    DynamoDBUpdateItemRequest *updateRequest = [[DynamoDBUpdateItemRequest alloc] initWithTableName:@"WhereYouApp" andKey:[[NSMutableDictionary alloc] initWithObjectsAndKeys:value ,@"username",nil] andAttributeUpdates:item];
    [_dynamoDBClient updateItem:updateRequest];
    
    // Remove user from group's list.
    [item removeAllObjects];
    value = [[DynamoDBAttributeValue alloc] initWithSS:[[NSMutableArray alloc] initWithObjects:[_username lowercaseString],nil]];
    updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"DELETE"];
    key = @"members";
    [item setValue:updateValue forKey:key];
    value = [[DynamoDBAttributeValue alloc] initWithN:groupID];
    updateRequest = [[DynamoDBUpdateItemRequest alloc] initWithTableName:@"WhereYouAppGroups" andKey:[[NSMutableDictionary alloc] initWithObjectsAndKeys:value ,@"groupID",nil] andAttributeUpdates:item];
    [_dynamoDBClient updateItem:updateRequest];
}

- (void) acceptGroupInvite:(NSString *)groupID {
    // Add group to user's group lists and remove invites.
    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
    DynamoDBAttributeValue *value = [[DynamoDBAttributeValue alloc] initWithNS:[[NSMutableArray alloc] initWithObjects:groupID,nil]];
    DynamoDBAttributeValueUpdate *updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"ADD"];
    NSString *key = @"groups";
    [item setValue:updateValue forKey:key];
    updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"DELETE"];
    key = @"groupRequests";
    [item setObject:updateValue forKey:key];
    
    value = [[DynamoDBAttributeValue alloc] initWithS: [_username lowercaseString]];
    DynamoDBUpdateItemRequest *updateRequest = [[DynamoDBUpdateItemRequest alloc] initWithTableName:@"WhereYouApp" andKey:[[NSMutableDictionary alloc] initWithObjectsAndKeys:value ,@"username",nil] andAttributeUpdates:item];
    [_dynamoDBClient updateItem:updateRequest];
    
    // Add user to group's memebr list and remove from invites.
    [item removeAllObjects];
    value = [[DynamoDBAttributeValue alloc] initWithSS:[[NSMutableArray alloc] initWithObjects:[_username lowercaseString],nil]];
    updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"ADD"];
    key = @"members";
    [item setValue:updateValue forKey:key];
    updateValue = [[DynamoDBAttributeValueUpdate alloc] initWithValue:value andAction:@"DELETE"];
    key = @"invites";
    [item setValue:updateValue forKey:key];
    value = [[DynamoDBAttributeValue alloc] initWithN:groupID];
    updateRequest = [[DynamoDBUpdateItemRequest alloc] initWithTableName:@"WhereYouAppGroups" andKey:[[NSMutableDictionary alloc] initWithObjectsAndKeys:value ,@"groupID",nil] andAttributeUpdates:item];
    [_dynamoDBClient updateItem:updateRequest];
}

@end
