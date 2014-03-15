//
//  WYAPasswordViewController.m
//  WhereYouApp
//
//  Created by Saloni Agarwal on 3/7/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAPasswordViewController.h"

@interface WYAPasswordViewController ()

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissKeyboardCurrent:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)dismissKeyboardNew:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)dissmissKeyboardRetype:(id)sender
{
    [sender resignFirstResponder];
}




@end
