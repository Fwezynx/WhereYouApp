//
//  WYAInviteUserTableViewController.m
//  WhereYouApp
//
//  Created by Timothy Chu on 3/26/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAInviteUserTableViewController.h"

@interface WYAInviteUserTableViewController ()

@property WYAUser *currentUser;
@property NSMutableArray *users;

@end

@implementation WYAInviteUserTableViewController

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
    [self.navigationItem setTitle:@"Invite Friends"];
#warning SQL query for friends not already in group.
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
    return [_users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [_users objectAtIndex:indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#warning invite user implementation
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView reloadData];
}

@end
