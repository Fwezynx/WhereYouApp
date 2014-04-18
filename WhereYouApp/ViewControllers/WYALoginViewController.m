//
//  WYALoginViewController.m
//  WhereYouApp
//
//  Created by Timothy Chu on 3/9/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYALoginViewController.h"

@interface WYALoginViewController ()

@property IBOutlet UIBarButtonItem *loginButton;
@property WYAUser *user;

@end


@implementation WYALoginViewController

@synthesize userField = _userField;
@synthesize passwordField = _passwordField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (sender == _loginButton) {
        // Make sure userField is filled.
        if (_userField.text.length == 0) {
            UIAlertView *noUserAlert = [[UIAlertView alloc] initWithTitle:@"No Username Provided" message:@"Please provide a username." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [noUserAlert show];
            return NO;
        }
        // Make sure password field is filled.
        if (_passwordField.text.length < 6) {
            UIAlertView *shortPassAlert = [[UIAlertView alloc] initWithTitle:@"Password Too Short" message:@"Please provide a password with length of at least 6." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [shortPassAlert show];
            return NO;
        }
        // Check login credentials.
        if ([_user userLogin:[_userField.text lowercaseString] withPassword:[WYAHash sha256:_passwordField.text]]) {
            [_user setUsername:_userField.text];
            return YES;
        }
        else {
            UIAlertView *invalidCredentialsAlert = [[UIAlertView alloc] initWithTitle:@"Invalid Login" message:@"Your username and password combination was not recognized.  Try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [invalidCredentialsAlert show];
            return NO;
        }
    }
    return YES;
}

- (IBAction)didPressLogin:(id)sender
{
    if ([self shouldPerformSegueWithIdentifier:@"mapView" sender:_loginButton]) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *newView = [mainStoryboard instantiateViewControllerWithIdentifier:@"mapView"];
        [self.navigationController setViewControllers:[[NSArray alloc] initWithObjects:newView, nil]];
    }
}

- (IBAction)unwindToLogin:(UIStoryboardSegue *)segue
{
    [_user setUsername:nil];
    [_user setFriendList:nil];
    [_user setGroupsList:nil];
    [_user setBlockedByUsersList:nil];
    [_user setBlockedFriendsList:nil];
    [_user setFriendRequestList:nil];
    [_user setGroupRequestList:nil];
    [_user setInvitedFriendsList:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _user = [WYAUser sharedInstance];
    [_passwordField setSecureTextEntry:YES];
    [_userField setDelegate:self];
    [_passwordField setDelegate:self];
    [_userField setReturnKeyType:UIReturnKeyDone];
    [_passwordField setReturnKeyType:UIReturnKeyDone];
    [_userField setTag:1];
    [_passwordField setTag:2];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    [_userField resignFirstResponder];
    [_passwordField resignFirstResponder];
}



@end
