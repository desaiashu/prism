//
//  TutorialViewController.m
//  Ghost
//
//  Created by Ashutosh Desai on 1/9/13.
//  Copyright (c) 2013 makegameswithus inc. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)end:(id)sender
{
	//Log an event that the tutorial has been complete (step 13)
	[MGWU logEvent:@"tutorial_step" withParams:@{@"step":[NSNumber numberWithInt:13]}];
	
	//Save that the tutorial was completed to NSUserDefaults
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"completedTutorial"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	//Pop the whole tutorial off the navigation stack, returning back to the menu
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	//Log event for each tutorial step completed, each segue has the step number (1-12) as the identifier in the storyboard
	[MGWU logEvent:@"tutorial_step" withParams:@{@"step":[NSNumber numberWithInt:[segue.identifier intValue]]}];
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
