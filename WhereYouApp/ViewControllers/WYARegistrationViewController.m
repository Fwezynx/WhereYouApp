//
//  WYARegistrationViewController.m
//  WhereYouApp
//
//  Created by Timothy Chu on 3/9/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYARegistrationViewController.h"

@interface WYARegistrationViewController ()

@property IBOutlet UITextField *userField;
@property IBOutlet UITextField *emailField;
@property IBOutlet UITextField *passwordField;
@property IBOutlet UITextField *confirmPasswordField;
@property IBOutlet UITextField *questionField;
@property IBOutlet UITextField *answerField;
@property IBOutlet UIBarButtonItem *registerButton;

@end

@implementation WYARegistrationViewController

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
	_passwordField.secureTextEntry = YES;
    _confirmPasswordField.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
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
        if ([self successfulRegistrationForUser:[WYAHash sha256:[_userField.text lowercaseString]] withPassword:[WYAHash sha256:_passwordField.text] withEmail:_emailField.text withSecurityQuestion:_questionField.text andSecurityAnswer:_answerField.text]) {
            return YES;
        }
        else {
            UIAlertView *userExistsAlert = [[UIAlertView alloc] initWithTitle:@"Username Already Exists" message:@"The username you selected is already in use.  Please try another name." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [userExistsAlert show];
            _passwordField.text = nil;
            _confirmPasswordField.text = nil;
            return NO;
        }
    }
    return YES;
}


- (BOOL) successfulRegistrationForUser:(NSString *)username withPassword:(NSString *)password withEmail:(NSString *)email withSecurityQuestion:(NSString *)question andSecurityAnswer:(NSString *)answer {
#warning Incomplete implementation
    return YES;
}

@end
