//
//  WYAFriendNotificationTableViewController.m
//  WhereYouApp
//
//  Created by Timothy Chu on 4/16/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAFriendNotificationTableViewController.h"

@interface WYAFriendNotificationTableViewController ()

@property WYAUser *currentUser;
@property NSIndexPath *index;

@end

@implementation WYAFriendNotificationTableViewController

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

- (void) viewDidAppear:(BOOL)animated {
#warning temporary hack
    [_currentUser updateInformation];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_currentUser.friendRequestList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [_currentUser.friendRequestList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _index = indexPath;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIAlertView *addUser = [[UIAlertView alloc] initWithTitle:cell.textLabel.text message:@"Would you like to add this user as a friend?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Friend", @"Ignore User", @"Block User", nil];
    [addUser show];
    
    [tableView reloadData];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView firstOtherButtonIndex]) {
        [_currentUser acceptFriendRequest:[alertView title]];
        [self.tableView reloadData];
    }
    else if (buttonIndex == [alertView firstOtherButtonIndex] + 1) {
        [_currentUser ignoreUser:[alertView title]];
        [self.tableView reloadData];
    }
    else if (buttonIndex == [alertView firstOtherButtonIndex] + 2) {
        [_currentUser blockUser:[alertView title]];
        [self.tableView reloadData];
    }
}

@end
