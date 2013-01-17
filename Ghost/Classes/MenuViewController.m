//
//  MenuViewController.m
//  Ghost
//
//  Created by Ashutosh Desai on 7/31/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
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
	
	//If returning to the menu from the game, hide the nav bar with animation, otherwise hide it without animation (when the user first opens the app)
	if (inGame)
	{
		[self.navigationController setNavigationBarHidden:YES animated:animated];
		inGame = FALSE;
	}
	else
		[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	//If player has not completed the tutorial yet, hide the other buttons, otherwise show them
	BOOL completedTutorial = [[NSUserDefaults standardUserDefaults] boolForKey:@"completedTutorial"];
	if (!completedTutorial)
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
	//If you're going into the game, show the navigation bar (since the menu and game share the same navigation controller)
	if (inGame)
		[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	//If you're entering the game, set the boolean to true
	if ([[segue identifier] isEqualToString:@"play"])
		inGame = TRUE;
	//Otherwise if you're entering the tutorial, log an event that the player has started the tutorial (step 0)
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
