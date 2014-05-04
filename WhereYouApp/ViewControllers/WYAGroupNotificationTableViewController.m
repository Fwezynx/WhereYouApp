//
//  WYAGroupNotificationTableViewController.m
//  WhereYouApp
//
//  Created by Timothy Chu on 4/16/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAGroupNotificationTableViewController.h"

@interface WYAGroupNotificationTableViewController ()

@property WYAUser *currentUser;

@end

@implementation WYAGroupNotificationTableViewController

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
    return [_currentUser.groupRequestList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSMutableArray *groupsList = [NSMutableArray arrayWithArray: [[_currentUser.groupRequestList allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    WYAGroups *group = [_currentUser.groupRequestList objectForKey:[groupsList objectAtIndex:indexPath.row]];
    [cell.textLabel setText:group.groupName];
    [cell setTag:[group.groupID intValue]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *groupID = [NSString stringWithFormat:@"%ld",(long)cell.tag];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WYAPendingGroupMembersTableViewController *newView = [mainStoryboard instantiateViewControllerWithIdentifier:@"PendingGroupMembers"];
    newView.groupID = groupID;
    [self.navigationController pushViewController:newView animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *groupID = [NSString stringWithFormat:@"%ld",(long)cell.tag];
    [_currentUser ignoreGroupInvite:groupID];
    [_currentUser.groupRequestList removeObjectForKey:groupID];
    // Request table view to reload
    [tableView reloadData];
}

@end
