//
//  WYALoginViewController.h
//  WhereYouApp
//
//  Created by Timothy Chu on 3/9/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYAHash.h"
#import "WYARegistrationViewController.h"
#import "WYAUser.h"
#import "WYAMapViewController.h"

@interface WYALoginViewController : UIViewController<UITextFieldDelegate>

- (IBAction)unwindToLogin:(UIStoryboardSegue *)segue;
- (IBAction)didPressLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end
