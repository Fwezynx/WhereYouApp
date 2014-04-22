//
//  WYAGroups.m
//  WhereYouApp
//
//  Created by Saloni Agarwal on 3/1/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAGroups.h"

@implementation WYAGroups

- (id) init {
    self = [super init];
    _groupMembers = [[NSMutableArray alloc] init];
    _invitedMembers = [[NSMutableArray alloc] init];
    return self;
}

@end
