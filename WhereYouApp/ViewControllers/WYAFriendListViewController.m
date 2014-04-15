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

- (void) viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
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
    [cell.textLabel setText:[_currentUser.friendList objectAtIndex:indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *username = cell.textLabel.text;
    [_currentUser removeUser:username];
    [_currentUser.friendList removeObject:username];
    // Request table view to reload
    [tableView reloadData];
}

@end
