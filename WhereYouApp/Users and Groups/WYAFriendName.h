//
//  WYAFriendName.h
//  WhereYouApp
//
//  Created by Basak Taylan on 3/2/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYAFriendName : NSObject

@property NSString *friendName;
@property BOOL completed;
@property (readonly) NSDate *creationDate;

@end
