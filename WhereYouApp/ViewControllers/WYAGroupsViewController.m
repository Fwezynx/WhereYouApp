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
#warning Implementation with database required.  User needs to be added to group
    if (source.group != nil) {
        WYAGroups *newGroup = [[WYAGroups alloc] init];
        [newGroup setGroupName:source.group];
        [_currentUser.groupsList addObject:newGroup];
        [self.tableView reloadData];
    }
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
    
    WYAGroups *groupName = [_currentUser.groupsList objectAtIndex:indexPath.row];
    cell.textLabel.text = groupName.groupName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    [_currentUser.groupsList removeObjectAtIndex:indexPath.row];
    
    // Request table view to reload
    [tableView reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Leave";
}

@end
