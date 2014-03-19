//
//  WYAFriendListViewController.m
//  WhereYouApp
//
//  Created by Basak Taylan on 3/2/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAFriendListViewController.h"

@interface WYAFriendListViewController ()

@property WYAUser *currentUser;

@end

@implementation WYAFriendListViewController

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    WYAAddFriendNameViewController *source = [segue sourceViewController];
#warning Implementation with database required.  User should be pending from here
    if (source.friendName != nil) {
        WYAUserAnnotation *friend = [[WYAUserAnnotation alloc] initWithUserName:source.friendName andCoordinate:_currentUser.locationManager.location.coordinate andAltitude:_currentUser.locationManager.location.altitude];
        [friend setStatus:2];
        [_currentUser.friendList addObject:friend];
        [_currentUser.friendRequestList addObject:friend];
        [self.tableView reloadData];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentUser = [WYAUser sharedInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_currentUser.friendList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    WYAUserAnnotation *friend = [_currentUser.friendList objectAtIndex:indexPath.row];
    [cell.textLabel setText:friend.title];
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning remove user from database required
    // Remove the row from data model
    [_currentUser.friendList removeObjectAtIndex:indexPath.row];
    
    // Request table view to reload
    [tableView reloadData];
}

@end
