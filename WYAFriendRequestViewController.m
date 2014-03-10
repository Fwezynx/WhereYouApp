//
//  WYAFriendRequestViewController.m
//  WhereYouApp
//
//  Created by Basak Taylan on 3/8/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAFriendRequestViewController.h"

@interface WYAFriendRequestViewController ()

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Do any additional setup after loading the view.
    _friendRequests =  [NSArray arrayWithObjects:@"Basak",@"Yuri",@"George", nil];
    int count = 0;
    int y=50;
    int x = 20;
    int x1=110;
    int x2 = 180;
    int x3 = 250;
    
    for (NSString *friend in _friendRequests) {
        
        UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 60, 64)];
        
        label.backgroundColor = [UIColor clearColor];
        label.tag = count;
        label.textColor=[UIColor blackColor];
        label.text = friend;
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
    

    
-(IBAction)addFriend:(id) sender{
    
    NSLog(@"added");
    
}
    
-(IBAction)ignoreFriend:(id) sender{
    
  //  NSLog(@"ignored");
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        if([sender tag] == [v tag])
            [v removeFromSuperview];
    }
    
}
-(IBAction)blockFriend:(id) sender{
    
  //  NSLog(@"blocked");
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        if([sender tag] == [v tag])
            [v removeFromSuperview];
    }
    
}
    


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
