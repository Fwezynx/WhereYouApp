//
//  WYAFriendRequestViewController.h
//  WhereYouApp
//
//  Created by Basak Taylan on 3/8/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYAFriendRequestViewController : UIViewController{}

@property NSArray *friendRequests;
-(IBAction)addFriend:(id)sender;
-(IBAction)ignoreFriend:(id)sender;
-(IBAction)blockFriend:(id)sender;
@end
