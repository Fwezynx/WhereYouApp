//
//  WYARegistrationViewController.h
//  WhereYouApp
//
//  Created by Timothy Chu on 3/9/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYAHash.h"
#import "WYAUser.h"

@interface WYARegistrationViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userField;


@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *questionField;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UITextField *answerField;


@end
