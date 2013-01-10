//
//  MenuViewController.m
//  Ghost
//
//  Created by Ashutosh Desai on 7/31/12.
//  Copyright (c) 2012 makegameswithus inc. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		inGame = FALSE;
    }
    return self;
}

- (IBAction)moreGames:(id)sender
{
	[MGWU displayCrossPromo];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if (inGame)
	{
		[self.navigationController setNavigationBarHidden:YES animated:animated];
		inGame = FALSE;
	}
	else
		[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	BOOL readInstructions = [[NSUserDefaults standardUserDefaults] boolForKey:@"readInstructions"];
	if (!readInstructions)
	{
		[play setHidden:YES];
		[moreGames setHidden:YES];
	}
	else
	{
		[play setHidden:NO];
		[moreGames setHidden:NO];
	}
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	if (inGame)
		[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"play"])
		inGame = TRUE;
	else if ([[segue identifier] isEqualToString:@"tutorial"])
		[MGWU logEvent:@"tutorial_step" withParams:@{@"step":[NSNumber numberWithInt:0]}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == [[UIApplication sharedApplication] statusBarOrientation]);
}

@end
