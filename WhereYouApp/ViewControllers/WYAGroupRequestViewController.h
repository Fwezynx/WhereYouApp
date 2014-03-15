//
//  WYAGroupRequestViewController.h
//  WhereYouApp
//
//  Created by Basak Taylan on 3/8/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYAGroupRequestViewController : UIViewController

@property NSMutableArray *groupRequests;

-(IBAction)ignoreGroup:(id) sender;
-(IBAction)addGroup:(id) sender;

@end
