//
//  WYAFriendListViewController.h
//  WhereYouApp
//
//  Created by Basak Taylan on 3/2/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYAAddFriendNameViewController.h"
#import "WYAUserAnnotation.h"
#import "WYAUser.h"

@interface WYAFriendListViewController : UITableViewController

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
