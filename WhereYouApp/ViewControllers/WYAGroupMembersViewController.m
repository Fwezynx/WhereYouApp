//
//  WYAGroupMembersViewController.m
//  WhereYouApp
//
//  Created by Timothy Chu on 3/24/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAGroupMembersViewController.h"

@interface WYAGroupMembersViewController ()

@property WYAUser *currentUser;
@property UIBarButtonItem *addButton;

@end

@implementation WYAGroupMembersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentUser = [WYAUser sharedInstance];
    [self.navigationItem setTitle:_group.groupName];
    _addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    [self.navigationItem setRightBarButtonItem:_addButton];
    [_addButton setTarget:self];
    [_addButton setAction:NSSelectorFromString(@"selector:")];
}

- (IBAction) selector:(id)sender
{
    if (sender == _addButton) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *newView = [mainStoryboard instantiateViewControllerWithIdentifier:@"InviteGroupMembers"];
        [self.navigationController pushViewController:newView animated:YES];
    }
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
    return [_group.groupMembers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = [_group.groupMembers objectAtIndex:indexPath.row];
    
    return cell;
}

@end
