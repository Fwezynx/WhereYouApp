//
//  WYAGroupsViewController.m
//  WhereYouApp
//
//  Created by Saloni Agarwal on 3/1/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAGroupsViewController.h"

@interface WYAGroupsViewController ()

@property WYAUser *currentUser;

@end

@implementation WYAGroupsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)unwindToGroups:(UIStoryboardSegue *)segue
{
    WYAAddGroupsViewController *source = [segue sourceViewController];
    if (source.group != nil) {
        NSString *groupID = [_currentUser createGroup:source.group];
        WYAGroups *newGroup = [[WYAGroups alloc] init];
        [newGroup setGroupName:source.group];
        [newGroup setGroupID:groupID];
        [_currentUser.groupsList setObject:newGroup forKey:groupID];
        [self.tableView reloadData];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentUser = [WYAUser sharedInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_currentUser.groupsList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSMutableArray *groups = [NSMutableArray arrayWithArray: [[_currentUser.groupsList allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    WYAGroups *group = [_currentUser.groupsList objectForKey:[groups objectAtIndex:indexPath.row]];
    [cell.textLabel setText:group.groupName];
    [cell setTag:[group.groupID intValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *groupID = [NSString stringWithFormat:@"%ld",(long)cell.tag];
    [_currentUser leaveGroup:groupID];
    [_currentUser.groupsList removeObjectForKey:groupID];
    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *groupID = [NSString stringWithFormat:@"%ld",(long)cell.tag];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WYAGroupMembersViewController *newView = [mainStoryboard instantiateViewControllerWithIdentifier:@"GroupMembers"];
    newView.groupID = groupID;
    [self.navigationController pushViewController:newView animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Leave";
}

@end
