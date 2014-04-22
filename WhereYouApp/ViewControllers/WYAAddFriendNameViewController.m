//
//  WYAAddFriendNameViewController.m
//  WhereYouApp
//
//  Created by Timothy Chu on 3/13/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAAddFriendNameViewController.h"

@interface WYAAddFriendNameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property WYAUser *currentUser;
@property NSString *friendName;

@end

@implementation WYAAddFriendNameViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != _doneButton) return;
    if (_textField.text.length > 0) {
        _friendName = _textField.text;
    }
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (sender != _doneButton) {
        return YES;
    }
    if (_textField.text.length > 0) {
        _friendName = _textField.text;
        // Prevent user from adding self
        if ([_currentUser.username isEqualToString:_friendName]) {
            UIAlertView *blockedByUserAlert = [[UIAlertView alloc] initWithTitle:@"Can't Add Self" message:@"You cannot add yourself as a friend." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [blockedByUserAlert show];
            return NO;
        }
        // User is already your friend
        if ([_currentUser.blockedByUsersList containsObject:[_friendName lowercaseString]]) {
            UIAlertView *blockedByUserAlert = [[UIAlertView alloc] initWithTitle:@"Already Friends" message:@"You are already friends with this user." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [blockedByUserAlert show];
            return NO;
        }
        // If user is blocking you
        if ([_currentUser.blockedByUsersList containsObject:[_friendName lowercaseString]]) {
            UIAlertView *blockedByUserAlert = [[UIAlertView alloc] initWithTitle:@"Blocked By User" message:@"This user has blocked you." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [blockedByUserAlert show];
            return NO;
        }
        // If your friendship is pending
        if ([_currentUser.invitedFriendsList containsObject:[_friendName lowercaseString]]) {
            UIAlertView *pendingUserAlert = [[UIAlertView alloc] initWithTitle:@"Friend Request Pending" message:@"You have already invited this user to be your friend." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [pendingUserAlert show];
            return NO;
        }
        // If friend is waiting on your approval
        if ([_currentUser.friendRequestList containsObject:[_friendName lowercaseString]]) {
            [_currentUser acceptFriendRequest:_friendName];
            return YES;
        }
        if ([_currentUser userExists:[_friendName lowercaseString]]) {
            // If you are blocking user
            if ([_currentUser.blockedFriendsList containsObject:[_friendName lowercaseString]]) {
                [_currentUser unblockUser:_friendName];
            }
            [_currentUser inviteFriend:_friendName];
            return YES;
        }
        UIAlertView *noUserAlert = [[UIAlertView alloc] initWithTitle:@"User Does Not Exist" message:@"Please provide an existing username." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [noUserAlert show];
        return NO;
    }
    UIAlertView *noUserAlert = [[UIAlertView alloc] initWithTitle:@"No Username Provided" message:@"Please provide a username." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [noUserAlert show];
    return NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentUser = [WYAUser sharedInstance];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
