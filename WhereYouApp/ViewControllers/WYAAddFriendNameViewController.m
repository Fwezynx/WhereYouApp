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

@end

@implementation WYAAddFriendNameViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.doneButton) return;
    if (self.textField.text.length > 0) {
        self.friendName = [[WYAFriendName alloc] init];
        self.friendName.friendName = self.textField.text;
        self.friendName.completed = NO;
    }
}


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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
