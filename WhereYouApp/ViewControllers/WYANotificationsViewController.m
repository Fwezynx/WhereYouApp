//
//  WYANotificationsViewController.m
//  WhereYouApp
//
//  Created by Basak Taylan on 3/8/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYANotificationsViewController.h"

@interface WYANotificationsViewController ()

@property IBOutlet UILabel *friendRequests;
@property IBOutlet UILabel *groupRequests;
@property WYAUser *currentUser;

@end

@implementation WYANotificationsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentUser = [WYAUser sharedInstance];
}

- (void)viewDidAppear:(BOOL)animated {
    [_friendRequests setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)[_currentUser.friendRequestList count]]];
    [_groupRequests setText:[NSString stringWithFormat:@"(%lu)",(unsigned long)[_currentUser.groupRequestList count]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
