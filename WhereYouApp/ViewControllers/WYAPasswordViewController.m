//
//  WYAPasswordViewController.m
//  WhereYouApp
//
//  Created by Saloni Agarwal on 3/7/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAPasswordViewController.h"

@interface WYAPasswordViewController ()

@property IBOutlet UITextField *oldPasswordField;
@property IBOutlet UITextField *passwordField;
@property IBOutlet UITextField *confirmPasswordField;

@end

@implementation WYAPasswordViewController

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
    [_oldPasswordField setSecureTextEntry:YES];
    [_passwordField setSecureTextEntry:YES];
    [_confirmPasswordField setSecureTextEntry:YES];
    [_oldPasswordField setDelegate:self];
    [_passwordField setDelegate:self];
    [_confirmPasswordField setDelegate:self];
    [_oldPasswordField setReturnKeyType:UIReturnKeyDone];
    [_passwordField setReturnKeyType:UIReturnKeyDone];
    [_confirmPasswordField setReturnKeyType:UIReturnKeyDone];
	[_oldPasswordField setTag:1];
    [_passwordField setTag:2];
    [_confirmPasswordField setTag:3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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




@end
