//
//  WYAGroups.h
//  WhereYouApp
//
//  Created by Saloni Agarwal on 3/1/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYAGroups : NSObject

@property NSString *groupName;
@property NSString *groupID;
@property NSMutableDictionary *groupMembers;
@property NSMutableArray *invitedMembers;
@property NSMutableArray *groupMemberNames;
//@property BOOL completed;
//@property (readonly) NSDate *creationDate;

@end
