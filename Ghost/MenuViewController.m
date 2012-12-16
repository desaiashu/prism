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
		inCrossPromo = FALSE;
		inInstructions = FALSE;
		timestamp = 0;
    }
    return self;
}

//Buttons to demonstrate features of SDK

- (IBAction)moreGames:(id)sender
{
	inCrossPromo = TRUE;
	[MGWU displayCrossPromo];
}

- (IBAction)about:(id)sender
{
	[MGWU displayAboutPage];
}

- (IBAction)likeMGWU:(id)sender
{
	[MGWU likeMGWU];
}

- (IBAction)likeNim:(id)sender
{
	[MGWU likeAppWithPageId:@"155368531182767"];
}

- (IBAction)inviteFriends:(id)sender
{
	[MGWU inviteFriendsWithMessage:@"Check out this cool app!"];
}

- (IBAction)share:(id)sender
{
	[MGWU shareWithTitle:@"Nim" caption:@"The best multiplayer iPhone Game" andDescription:@"I'm beating you!!!"];
}

- (IBAction)contact:(id)sender
{
	[MGWU displayHipmob];
}

- (IBAction)testBuy:(id)sender
{
	[MGWU testBuyProduct:@"com.mgwu.kw.5000C" withCallback:@selector(test:) onTarget:self];
}

- (IBAction)buy:(id)sender
{
	[MGWU buyProduct:@"com.mgwu.kw.CD" withCallback:@selector(test:) onTarget:self];
}

- (IBAction)testRestore:(id)sender
{
	[MGWU testRestoreProducts:@[@"com.mgwu.kw.CD"] withCallback:@selector(test:) onTarget:self];
}

- (IBAction)restore:(id)sender
{
	[MGWU restoreProductsWithCallback:@selector(test:) onTarget:self];
}

-(void)test:(NSArray*)dude
{
	NSLog(@"foo");
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if (!inCrossPromo)
		[self.navigationController setNavigationBarHidden:YES animated:animated];
	else
		inCrossPromo = FALSE;
	
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
	
	if (inInstructions)
	{
		inInstructions = false;
		if (timestamp > 0)
		{
			int readingTime = [[NSDate date] timeIntervalSince1970] - timestamp;
			[MGWU logEvent:@"read_instructions" withParams:@{@"reading_time":[NSNumber numberWithInt:readingTime]}];
			timestamp = 0;
		}
	}
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	if (!inCrossPromo)
		[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"readInstructions"])
	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"readInstructions"];
		inInstructions = true;
		timestamp = [[NSDate date] timeIntervalSince1970];
	}
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
