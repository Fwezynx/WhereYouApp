//
//  WYAAddFriendName.m
//  WhereYouApp
//
//  Created by Basak Taylan on 3/2/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAAddFriendName.h"
#import "WYAFriendName.h"

@interface WYAAddFriendName ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation WYAAddFriendName

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
