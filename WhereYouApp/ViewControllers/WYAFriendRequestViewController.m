//
//  WYAFriendRequestViewController.m
//  WhereYouApp
//
//  Created by Basak Taylan on 3/8/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAFriendRequestViewController.h"

@interface WYAFriendRequestViewController ()

@property WYAUser *currentUser;

@end

@implementation WYAFriendRequestViewController

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
    _currentUser = [WYAUser sharedInstance];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Do any additional setup after loading the view.
    int count = 0;
    int y=50;
    int x = 20;
    int x1=110;
    int x2 = 180;
    int x3 = 250;
    
    for (WYAUserAnnotation *friend in _currentUser.friendRequestList) {
        
        UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 60, 64)];
        
        label.backgroundColor = [UIColor clearColor];
        label.tag = count;
        label.textColor=[UIColor blackColor];
        label.text = friend.title;
        [self.view addSubview:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(x1, y, 64, 64);
        button.tag = count;
        [button setTitle:@"Add" forState:UIControlStateNormal];
        [button addTarget:self action:NSSelectorFromString(@"addFriend:") forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        
        
        
        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button2.frame = CGRectMake(x2, y, 64, 64);
        button2.tag = count;
        [button2 setTitle:@"Ignore" forState:UIControlStateNormal];
        [button2 addTarget:self action:NSSelectorFromString(@"ignoreFriend:") forControlEvents:UIControlEventTouchUpInside];
        //[button2 setBackgroundColor:[UIColor blueColor]];
        [self.view addSubview:button2];
        
        UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button3.frame = CGRectMake(x3, y, 64, 64);
        button3.tag = count;
        [button3 setTitle:@"Block" forState:UIControlStateNormal];
        [button3 addTarget:self action:NSSelectorFromString(@"blockFriend:") forControlEvents:UIControlEventTouchUpInside];
        //  [button3 setBackgroundColor:[UIColor redColor]];
        
        [self.view addSubview:button3];
        
        y= y + 20;
        count++;
    }
    
    
}
    

#warning need to implement with databases.
-(IBAction)addFriend:(id) sender {

    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        if([sender tag] == [v tag]) {
            [v removeFromSuperview];
        }
    }
}

-(IBAction)ignoreFriend:(id) sender {
    
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        if([sender tag] == [v tag]) {
            [v removeFromSuperview];
        }
    }
}
-(IBAction)blockFriend:(id) sender {
    
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
