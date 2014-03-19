//
//  WYAGroupRequestViewController.m
//  WhereYouApp
//
//  Created by Basak Taylan on 3/8/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAGroupRequestViewController.h"

@interface WYAGroupRequestViewController ()

@property WYAUser *currentUser;

@end

@implementation WYAGroupRequestViewController

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
	_currentUser = [WYAUser sharedInstance];
    int count = 0;
    int y=50;
    int x = 20;
    int x1=110;
    int x2 = 180;
    
    for (WYAGroups *group in _currentUser.groupRequestList) {
        
        UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 110, 60)];
       
        label.backgroundColor = [UIColor clearColor];
        label.tag = count;
        label.textColor=[UIColor blackColor];
        label.text = group.groupName;
        [self.view addSubview:label];
       
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(x1, y, 64, 64);
        button.tag = count;
        [button setTitle:@"Add" forState:UIControlStateNormal];
        [button addTarget:self action:NSSelectorFromString(@"addGroup:") forControlEvents:UIControlEventTouchUpInside];
        //[button2 setBackgroundColor:[UIColor blueColor]];
        [self.view addSubview:button];

        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button2.frame = CGRectMake(x2, y, 64, 64);
        button2.tag = count;
        [button2 setTitle:@"Ignore" forState:UIControlStateNormal];
        [button2 addTarget:self action:NSSelectorFromString(@"ignoreGroup:") forControlEvents:UIControlEventTouchUpInside];
        //[button2 setBackgroundColor:[UIColor blueColor]];
        [self.view addSubview:button2];

      
      //  [button2 addTarget:self action:@selector(ignoreGroup) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button2];
        y= y + 20;
        count++;

       
         //NSLog(@"you are %@", group);
        
    }
    
    
}

-(IBAction)addGroup:(id) sender {
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        if([sender tag] == [v tag]) {
            [v removeFromSuperview];
        }
    }
}

-(IBAction)ignoreGroup:(id) sender {
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        if([sender tag] == [v tag]) {
            [v removeFromSuperview];
        }
    }
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
