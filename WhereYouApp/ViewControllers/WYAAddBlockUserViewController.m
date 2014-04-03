//
//  WYAAddBlockUserViewController.m
//  WhereYouApp
//
//  Created by Saloni Agarwal on 3/8/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAAddBlockUserViewController.h"

@interface WYAAddBlockUserViewController ()

@property WYAUser *currentUser;

@end

@implementation WYAAddBlockUserViewController

#warning method needs to be removed.
-(void) loadInitialDatas
{
    CLLocationDistance alt = _currentUser.locationManager.location.altitude;
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(_currentUser.locationManager.location.coordinate.latitude, _currentUser.locationManager.location.coordinate.longitude);
    
    WYAUserAnnotation *user = [[WYAUserAnnotation alloc] initWithUserName:@"John" andCoordinate:coords andAltitude:alt];
    [_currentUser.blockedFriendsList addObject:user];
    user = [[WYAUserAnnotation alloc] initWithUserName:@"Rick" andCoordinate:coords andAltitude:alt];
    [_currentUser.blockedFriendsList addObject:user];
}

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
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    [self loadInitialDatas];
    });
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [_currentUser.blockedFriendsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCellBlock";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    WYAUserAnnotation *userName = [_currentUser.blockedFriendsList objectAtIndex:indexPath.row];
    [cell.textLabel setText:userName.title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_currentUser.blockedFriendsList removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Unblock";
}

@end
