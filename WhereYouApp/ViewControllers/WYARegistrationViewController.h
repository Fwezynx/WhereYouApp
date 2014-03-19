//
//  WYARegistrationViewController.h
//  WhereYouApp
//
//  Created by Timothy Chu on 3/9/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYAHash.h"

@interface WYARegistrationViewController : UIViewController<UITextFieldDelegate>

- (BOOL) successfulRegistrationForUser:(NSString *)username withPassword:(NSString *)password withEmail:(NSString *)email withSecurityQuestion:(NSString *)question andSecurityAnswer:(NSString *)answer;

@end
