//
//  WYAGroupRequestViewController.m
//  WhereYouApp
//
//  Created by Basak Taylan on 3/8/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import "WYAGroupRequestViewController.h"

@interface WYAGroupRequestViewController ()

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
	// Do any additional setup after loading the view.
    _groupRequests =  [NSArray arrayWithObjects:@"Josh's Group",@"Ali's Group",nil];
    int count = 0;
    int y=50;
    int x = 20;
    int x1=110;
    int x2 = 180;
    
    for (NSString *group in _groupRequests) {
        
        UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 110, 100)];
       
        label.backgroundColor = [UIColor clearColor];
        label.tag = count++;
        label.textAlignment = UITextAlignmentLeft; // UITextAlignmentCenter, UITextAlignmentLeft
        label.textColor=[UIColor blackColor];
        label.text = group;
        [self.view addSubview:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(x1, y, 150, 100);
        [button setTitle:@"Add" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addGroup) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button2.frame = CGRectMake(x2, y, 150, 100);
        [button2 setTitle:@"Ignore" forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(ignoreGroup) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button2];
       
        y= y + 20;

       
         //NSLog(@"you are %@", group);
        
    }
    

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
