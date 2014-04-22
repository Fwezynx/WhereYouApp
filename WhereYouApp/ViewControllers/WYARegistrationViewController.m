//
//  WYARegistrationViewController.m
//  WhereYouApp
//
//  Created by Timothy Chu on 3/9/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYARegistrationViewController.h"

@interface WYARegistrationViewController ()


@property IBOutlet UIBarButtonItem *registerButton;
@property WYAUser *currentUser;

@end

@implementation WYARegistrationViewController

@synthesize userField = _userField;
@synthesize emailField = _emailField;
@synthesize passwordField = _passwordField;
@synthesize confirmPasswordField = _confirmPasswordField;
@synthesize questionField = _questionField;
@synthesize answerField = _answerField;
@synthesize scroll;

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
    scroll.scrollEnabled = YES;
    [scroll setContentSize:CGSizeMake(300, 1000)];
    _currentUser = [WYAUser sharedInstance];
    [_passwordField setSecureTextEntry:YES];
    [_confirmPasswordField setSecureTextEntry:YES];
    [_userField setDelegate:self];
    [_emailField setDelegate:self];
    [_passwordField setDelegate:self];
    [_confirmPasswordField setDelegate:self];
    [_questionField setDelegate:self];
    [_answerField setDelegate:self];
    [_userField setReturnKeyType:UIReturnKeyDone];
    [_emailField setReturnKeyType:UIReturnKeyDone];
    [_passwordField setReturnKeyType:UIReturnKeyDone];
    [_confirmPasswordField setReturnKeyType:UIReturnKeyDone];
    [_questionField setReturnKeyType:UIReturnKeyDone];
    [_answerField setReturnKeyType:UIReturnKeyDone];
    [_userField setTag:1];
    [_emailField setTag:2];
    [_passwordField setTag:3];
    [_confirmPasswordField setTag:4];
    [_questionField setTag:5];
    [_answerField setTag:6];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (sender == _registerButton) {
        // Make sure userField is filled.
        if (_userField.text.length == 0) {
            UIAlertView *noUserAlert = [[UIAlertView alloc] initWithTitle:@"No Username Provided" message:@"Please provide a username." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [noUserAlert show];
            _passwordField.text = nil;
            _confirmPasswordField.text = nil;
            return NO;
        }
        // Make sure email field is filled.
        if (_emailField.text.length == 0) {
            UIAlertView *noEmailAlert = [[UIAlertView alloc] initWithTitle:@"No Email Provided" message:@"Please provide an email address." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [noEmailAlert show];
            _passwordField.text = nil;
            _confirmPasswordField.text = nil;
            return NO;
        }
        // Make sure password field is filled.
        if (_passwordField.text.length < 6) {
            UIAlertView *shortPassAlert = [[UIAlertView alloc] initWithTitle:@"Password Too Short" message:@"Please provide a password with length of at least 6." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [shortPassAlert show];
            _passwordField.text = nil;
            _confirmPasswordField.text = nil;
            return NO;
        }
        // Make sure passwords match.
        if (![_passwordField.text isEqualToString:_confirmPasswordField.text]) {
            UIAlertView *noMatchingPassAlert = [[UIAlertView alloc] initWithTitle:@"Passwords Do Not Match" message:@"Please make sure your password matches in the confirmation field." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [noMatchingPassAlert show];
            _passwordField.text = nil;
            _confirmPasswordField.text = nil;
            return NO;
        }
        // Make sure question field is filled.
        if (_questionField.text.length == 0) {
            UIAlertView *noQuestionAlert = [[UIAlertView alloc] initWithTitle:@"No Security Question" message:@"Please provide a security question." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [noQuestionAlert show];
            _passwordField.text = nil;
            _confirmPasswordField.text = nil;
            return NO;
        }
        // Make sure answer field is filled.
        if (_answerField.text.length == 0) {
            UIAlertView *noAnswerAlert = [[UIAlertView alloc] initWithTitle:@"No Security Answer" message:@"Please provide a security answer." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [noAnswerAlert show];
            _passwordField.text = nil;
            _confirmPasswordField.text = nil;
            return NO;
        }
        // Check registration availability.
        if ([_currentUser userExists:[_userField.text lowercaseString]]) {
            UIAlertView *userExistsAlert = [[UIAlertView alloc] initWithTitle:@"Username Already Exists" message:@"The username you selected is already in use.  Please try another name." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [userExistsAlert show];
            _passwordField.text = nil;
            _confirmPasswordField.text = nil;
            return NO;
        }
        // Register user
        return [_currentUser createUser:[_userField.text lowercaseString] withPassword:[WYAHash sha256:_passwordField.text] email:_emailField.text question:_questionField.text answer:[WYAHash sha256:[_answerField.text lowercaseString]]];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
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

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_confirmPasswordField resignFirstResponder];
    [_questionField resignFirstResponder];
    [_answerField resignFirstResponder];
}

@end
