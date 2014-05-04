//
//  WYAPendingGroupMembersTableViewController.m
//  WhereYouApp
//
//  Created by Timothy Chu on 4/16/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAPendingGroupMembersTableViewController.h"

@interface WYAPendingGroupMembersTableViewController ()

@property WYAUser *currentUser;
@property UIBarButtonItem *addButton;
@property UIBarButtonItem *removeButton;

@end

@implementation WYAPendingGroupMembersTableViewController

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
    WYAGroups *group = [_currentUser.groupsList objectForKey:_groupID];
    [self.navigationItem setTitle:group.groupName];
    _addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    [self.navigationItem setRightBarButtonItem:_addButton];
    [_addButton setTarget:self];
    [_addButton setAction:NSSelectorFromString(@"selector:")];
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
    WYAGroups *group = [_currentUser.groupRequestList objectForKey:_groupID];
    return [group.invitedMembers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    WYAGroups *group = [_currentUser.groupRequestList objectForKey:_groupID];
    [cell.textLabel setText:[group.groupMembers objectAtIndex:indexPath.row]];
    
    return cell;
}

- (IBAction) selector:(id)sender
{
    if (sender == _addButton) {
        [_currentUser acceptGroupInvite:_groupID];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
