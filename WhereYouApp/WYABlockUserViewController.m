//
//  WYABlockUserViewController.m
//  WhereYouApp
//
//  Created by Saloni Agarwal on 3/7/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYABlockUserViewController.h"

@interface WYABlockUserViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *blockButton;

@end

@implementation WYABlockUserViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.blockButton) return;
    if (self.textField.text.length > 0)
    {
        self.User = [[WYABlockUsers alloc] init];
        self.User.blockUserName = self.textField.text;
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


- (IBAction)dismissKeyboardBlock:(id)sender
{
    [sender resignFirstResponder];
}

@end
