//
//  TabBarController.m
//  Ghost
//
//  Created by Ashutosh Desai on 9/3/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
//

#import "TabBarController.h"
#import "AppDelegate.h"

@interface TabBarController ()

@end

@implementation TabBarController

@synthesize pvc;

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
	
	//Customize tab bar using Appearance APIs
	//Set custom background image
	[[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"TabBar.png"]];
	//Set custom selected image (this shows up behind the tab bar icons)
	[[UITabBar appearance] setSelectionIndicatorImage:[[UIImage imageNamed:@"TabBarSelected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
	
	//Set references to the actual view controllers
	gvc = (GamesViewController*)[self.viewControllers objectAtIndex:0];
	pvc = (PlayersViewController*)[self.viewControllers objectAtIndex:1];
	ivc = (InviteViewController*)[self.viewControllers objectAtIndex:2];
	
	//Set the tab bar icons for each view
	[gvc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"GhostIconSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"GhostIcon.png"]];
	[pvc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"PlusIconSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"PlusIcon.png"]];
	[ivc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"PersonIconSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"PersonIcon.png"]];
	
	//The text on back buttons is by default the title of the previous view controller, we don't want text on the button, so this removes it. This actually controls the text on the back button for any view pushed on top of this view controller.
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	
	counter = 0;
}

//When the view is about to appear, getMyInfo
- (void)viewWillAppear:(BOOL)animated
{
	[MGWU getMyInfoWithCallback:@selector(loadedUserInfo:) onTarget:self];
}

//Refresh user info
- (void)refresh
{
	[MGWU getMyInfoWithCallback:@selector(loadedUserInfo:) onTarget:self];
}

//Take user to update screen if he taps download update (see first bit of code in loadedUserInfo method)
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView == updateAlertView)
	{
		if (updateAlertView.numberOfButtons == 1 || buttonIndex == 1)
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateURL]];
		else
			[updateAlertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
		updateAlertView = nil;
	}
}

//Callback for getmyInfo
- (void)loadedUserInfo:(NSMutableDictionary*)userInfo
{
	//Checks whether the server has any info about a new version, prompts user to update, or forces user to update depending on response from server
	if ([[userInfo allKeys] containsObject:@"appversion"])
	{
		updateURL = [userInfo objectForKey:@"updateurl"];
		NSString *latestVersion = [userInfo objectForKey:@"appversion"];
		NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
		if ([curVersion compare:latestVersion options:NSNumericSearch] == NSOrderedAscending)
		{
			if (!updateAlertView)
			{
				if ([[userInfo allKeys] containsObject:@"forceupdate"])
					updateAlertView = [[UIAlertView alloc] initWithTitle:@"Update Required" message:@"You must download the latest update to continue playing" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Download Now!", nil];
				else
					updateAlertView = [[UIAlertView alloc] initWithTitle:@"Update Available" message:@"A new update has been released on the app store" delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Download Now!", nil];
				[updateAlertView show];
			}
		}
	}
	
	//Set variables to save data retrieved
	user = [userInfo objectForKey:@"info"];
	gvc.games = [userInfo objectForKey:@"games"];
	pvc.players = [userInfo objectForKey:@"friends"];
	ivc.nonPlayers = [MGWU friendsToInvite];
	
	NSArray *playingFriends = [NSArray arrayWithArray:pvc.players];
	
	if (!self.selectedIndex == 1)
	{
		//Set tab bar badge on PlayersViewController to alert user that new friends have joined the game
		int numOldFriends = [[NSUserDefaults standardUserDefaults] integerForKey:@"numFriends"];
		int numNewFriends = [pvc.players count];
		if (numNewFriends > numOldFriends)
		{
			pvc.newFriends = numNewFriends-numOldFriends;
		}
	}
	
	//Some open graph magic
	if (counter%3 == 0)
	{
		NSMutableArray *followedFriends = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"og_followed"]];
		NSMutableArray *ogPlayingFriends = [[NSMutableArray alloc] init];
		for (NSMutableDictionary *p in pvc.players)
		{
			[ogPlayingFriends addObject:[p objectForKey:@"username"]];
		}
		NSPredicate *relativeComplementPredicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@", followedFriends];
		NSArray *relativeComplement = [ogPlayingFriends filteredArrayUsingPredicate:relativeComplementPredicate];
		if ([relativeComplement count] > 0)
		{
			int r = arc4random()%[relativeComplement count];
			NSString *usernameToFollow = [relativeComplement objectAtIndex:r];
			[followedFriends addObject:usernameToFollow];
			[[NSUserDefaults standardUserDefaults] setObject:followedFriends forKey:@"og_followed"];
			//Publish OG
			NSString *opid = [MGWU fbidFromUsername:usernameToFollow];
			[MGWU publishOpenGraphAction:@"follow" withParams:@{@"profile":opid}];
		}
	}
	counter++;
	
	//Split up games based on whose turn it is / whether the game is over
	gvc.gamesCompleted = [[NSMutableArray alloc] init];
	gvc.gamesYourTurn = [[NSMutableArray alloc] init];
	gvc.gamesTheirTurn = [[NSMutableArray alloc] init];
	
	NSString *username = [user objectForKey:@"username"];
	
	for (NSMutableDictionary *game in gvc.games)
	{
		NSString* gameState = [game objectForKey:@"gamestate"];
		NSString* turn = [game objectForKey:@"turn"];
		
		NSString* oppName;
		NSArray* gamers = [game objectForKey:@"players"];
		if ([[gamers objectAtIndex:0] isEqualToString:username])
			oppName = [gamers objectAtIndex:1];
		else
			oppName = [gamers objectAtIndex:0];

		if ([gameState isEqualToString:@"ended"])
		{
			[gvc.gamesCompleted addObject:game];
			for (NSMutableDictionary *friend in playingFriends)
			{
				//Add friendName to game if you're friends
				if ([[friend objectForKey:@"username"] isEqualToString:oppName])
				{
					[game setObject:[friend objectForKey:@"name"] forKey:@"friendName"];
					break;
				}
			}
		}
		else if ([turn isEqualToString:[user objectForKey:@"username"]])
		{
			//Preventing cheating by storing your turn games in NSUserDefaults through MGWU encryption, this is game specific to Ghost
			NSString *gameID = [NSString stringWithFormat:@"%@",[game objectForKey:@"gameid"]];
			NSMutableDictionary *savedGame = [NSMutableDictionary dictionaryWithDictionary:[MGWU objectForKey:gameID]];
			if ([savedGame isEqualToDictionary:@{}])
				savedGame = game;
			else
				[savedGame setObject:[game objectForKey:@"newmessages"] forKey:@"newmessages"];
			[gvc.gamesYourTurn addObject:savedGame];
			//End ghost specific code
			
			for (NSMutableDictionary *friend in playingFriends)
			{
				//Add friendName to game if you're friends, remove the friend from list of players (so you can't start a new game with someone you're already playing)
				if ([[friend objectForKey:@"username"] isEqualToString:oppName])
				{
					[savedGame setObject:[friend objectForKey:@"name"] forKey:@"friendName"];
					[pvc.players removeObject:friend];
					break;
				}
			}
		}
		else
		{
			[gvc.gamesTheirTurn addObject:game];
			for (NSMutableDictionary *friend in playingFriends)
			{
				//Add friendName to game if you're friends, remove the friend from list of players (so you can't start a new game with someone you're already playing)
				if ([[friend objectForKey:@"username"] isEqualToString:oppName])
				{
					[game setObject:[friend objectForKey:@"name"] forKey:@"friendName"];
					[pvc.players removeObject:friend];
					break;
				}
			}
		}
	}
	
	//Create set of recommended friends
	pvc.recommendedFriends = [[NSMutableArray alloc] init];
	
	NSMutableArray *randomPlayingFriends = [NSMutableArray arrayWithArray:pvc.players];
	NSMutableArray *randomNonPlayingFriends = [NSMutableArray arrayWithArray:[MGWU friendsToInvite]];
	
	//Shuffle list of friends who play the game
	if ([randomPlayingFriends count] > 0)
	{
		for (NSUInteger i = [randomPlayingFriends count] - 1; i >= 1; i--)
		{
			u_int32_t j = arc4random_uniform(i + 1);
			
			[randomPlayingFriends exchangeObjectAtIndex:j withObjectAtIndex:i];
		}
	}
	
	//Shuffle list of friends who don't play yet
	if ([randomNonPlayingFriends count] > 0)
	{
		for (NSUInteger i = [randomNonPlayingFriends count] - 1; i >= 1; i--)
		{
			u_int32_t j = arc4random_uniform(i + 1);
			
			[randomNonPlayingFriends exchangeObjectAtIndex:j withObjectAtIndex:i];
		}
	}
	
	int i;
	//First add up to 2 friends who currently play the game
	for (i = 0; i < 2 && i < [randomPlayingFriends count]; i++)
	{
		[pvc.recommendedFriends addObject:[randomPlayingFriends objectAtIndex:i]];
	}
	//Then add friends who don't play for a maximum of 3 total recommended friends
	for (int j = i; j < 3 && (j-i < [randomNonPlayingFriends count]); j++)
	{
		[pvc.recommendedFriends addObject:[randomNonPlayingFriends objectAtIndex:(j-i)]];
	}
	
	//Set badges on tab bar based on games that are your turn and new friends who are playing
	if ([gvc.gamesYourTurn count] == 0)
		gvc.tabBarItem.badgeValue = nil;
	else
		gvc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [gvc.gamesYourTurn count]];
	
	if (pvc.newFriends == 0)
		pvc.tabBarItem.badgeValue = nil;
	else
		pvc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", pvc.newFriends];
	
	//Reload all views, and stop all pull to refresh from happening
	[gvc.tView reloadData];
	[gvc.pr stopLoading];
	[pvc.tView reloadData];
	[pvc.pr stopLoading];
	[ivc.tView reloadData];
	[ivc.pr stopLoading];
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
