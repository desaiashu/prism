//
//  FirstViewController.m
//  Ghost
//
//  Created by Ashutosh Desai on 7/11/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
//

#import "ChatViewController.h"
#import "AppDelegate.h"
#import "TabBarController.h"
#import "FriendsTableViewCell.h"
#import "ChatTableViewCell.h"
#import "Security.h"

@interface GamesViewController ()

@end

@implementation GamesViewController

@synthesize games, gamesCompleted, gamesYourTurn, gamesTheirTurn, tView, pr;

- (void)viewDidAppear:(BOOL)animated
{
	[self refresh];
}

- (void)refresh
{
	[MGWU getMyInfoWithCallback:@selector(loadedUserInfo:) onTarget:self];
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
	games = [userInfo objectForKey:@"games"];
	
//	//Split up games based on whose turn it is / whether the game is over
//	gamesCompleted = [[NSMutableArray alloc] init];
//	gamesYourTurn = [[NSMutableArray alloc] init];
//	gamesTheirTurn = [[NSMutableArray alloc] init];
//	
//	NSString *username = [user objectForKey:@"username"];
//	
//	int messages = 0;
//	
//	for (NSMutableDictionary *game in games)
//	{
//		NSString* gameState = [game objectForKey:@"gamestate"];
//		NSString* turn = [game objectForKey:@"turn"];
//		
//		NSString* oppName;
//		NSArray* gamers = [game objectForKey:@"players"];
//		if ([[gamers objectAtIndex:0] isEqualToString:username])
//			oppName = [gamers objectAtIndex:1];
//		else
//			oppName = [gamers objectAtIndex:0];
//		
//		if ([gameState isEqualToString:@"ended"])
//		{
//			[gamesCompleted addObject:game];
//		}
//		else if ([turn isEqualToString:[user objectForKey:@"username"]])
//		{
//			[gamesYourTurn addObject:game];
//		}
//		else
//		{
//			[gamesTheirTurn addObject:game];
//		}
//		
//		messages += [[game objectForKey:@"newmessages"] intValue];
//	}
//	
//	//Set badges on tab bar based on games that are your turn and new friends who are playing
//	if (messages + [gamesYourTurn count] == 0)
//		self.navigationController.tabBarItem.badgeValue = nil;
//	else
//		self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", messages + [gamesYourTurn count]];
	
	//Reload all views, and stop all pull to refresh from happening
	[tView reloadData];
	[pr stopLoading];
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

//Methods for pull to refresh, will automatically call "refresh" when pulled
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[pr scrollViewWillBeginDragging:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[pr scrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[pr scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (IBAction)go:(id)sender
{
	[self checkUsername];
}

//Method to send message when done is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self checkUsername];
	return YES;
}

- (void)checkUsername
{
	if ([usernameField.text isEqualToString:@""])
		return;
	
	[MGWU checkUsername:usernameField.text withCallback:@selector(gotUsername:) onTarget:self];
}

- (void)textFieldChanged:(NSNotification *)notif
{
	NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
	usernameField.text = [usernameField.text stringByTrimmingCharactersInSet:charactersToRemove];
	usernameField.text = [usernameField.text lowercaseString];
}

- (void)gotUsername:(NSString*)user
{
	if (user)
	{
		[MGWU overrideUsername:usernameField.text];
		usernameView.hidden = true;
		[usernameField resignFirstResponder];
		tView.hidden = false;
		newChat.hidden = false;
		[self refresh];
	}
}

//3 sections in table view, your turn, waiting for opponent, completed games
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

////Set height of section headers
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//	return [UIElements heightForFriendCell];
//}

////Customize look of section header, give it background, line, custom fonts and set the title based on which section it is
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//	UIView *t = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//	
//	UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HeaderBackground"]];
//	
//	UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 28)];
//	l.textColor = [UIColor colorWithRed:(223.0/256.0) green:(228.0/256.0) blue:(227.0/256.0) alpha:1.0];
//	l.font = [UIFont fontWithName:@"Nexa Bold" size:28.0];
//	l.backgroundColor = [UIColor clearColor];
//	if ([gamesYourTurn count] > 0 && section == 0)
//		l.text =  @"REQUESTS";
//	else
//		l.text = @"MESSAGES";
//	
//	UIView *b = [[UIView alloc] initWithFrame:CGRectMake(5, 32, 310, 2)];
//	b.backgroundColor = [UIColor colorWithRed:(223.0/256.0) green:(228.0/256.0) blue:(227.0/256.0) alpha:1.0];
//	
//	[t addSubview:v];
//	[t addSubview:l];
//	[t addSubview:b];
//	
//	return t;
//}

//Set number of rows based on arrays of games (filtered in tabBarController)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [games count];
}

//Since our cells are custom cells, we need to return the height of each row
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [UIElements heightForFriendCell];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Create cell as TableViewCell, our custom cell class
	NSString *CellIdentifier;
	FriendsTableViewCell *cell;
	BOOL pending = false;
	
	CellIdentifier = @"Cell";
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[FriendsTableViewCell alloc]
				initWithStyle:UITableViewCellStyleDefault
				reuseIdentifier:CellIdentifier];
	}

	NSDictionary *game = [games objectAtIndex:indexPath.row];

	NSString* name;
	NSArray* players = [game objectForKey:@"players"];
	if ([[players objectAtIndex:0] isEqualToString:[user objectForKey:@"username"]])
		name = [players objectAtIndex:1];
	else
		name = [players objectAtIndex:0];
	
	cell.name.text = name;
	
	NSString* gameState = [game objectForKey:@"gamestate"];
	NSString* turn = [game objectForKey:@"turn"];
	
	if ([gameState isEqualToString:@"ended"])
	{
		cell.status.text = @"chat with";
	}
	else if ([turn isEqualToString:name])
	{
		cell.status.text = @"request sent";
	}
	else
	{
		cell.status.text = @"request from";
		pending = TRUE;
	}
	
	//Set labels for name and action
//	cell.textLabel.text = name;
	
//	if (pending)
//	{
//		ChatTableViewCell *c = (ChatTableViewCell*)cell;
//		c.accept.tag = indexPath.row;
//		[c.accept addTarget:self action:@selector(accept:) forControlEvents:UIControlEventTouchUpInside];
//		c.reject.tag = indexPath.row;
//		[c.reject addTarget:self action:@selector(reject:) forControlEvents:UIControlEventTouchUpInside];
//	}

	//Add chat icon indicater if there are new messages
	int newmessages = [[game objectForKey:@"newmessages"] intValue];
	if (newmessages > 0)
	{
		if (!cell.unread)
		{
			cell.unread = [UIElements friendUnread:newmessages];
			[cell addSubview:cell.unread];
		}
	}
	else if(cell.unread)
	{
		[cell.unread removeFromSuperview];
		cell.unread = nil;
	}
	
    return cell;
}

- (void)accept:(id)sender
{
	int index = [(UIButton*)sender tag];
	NSDictionary *game = [gamesYourTurn objectAtIndex:index];
	int gameid = [[game objectForKey:@"gameid"] intValue];
	NSString* name;
	NSArray* players = [game objectForKey:@"players"];
	if ([[players objectAtIndex:0] isEqualToString:[user objectForKey:@"username"]])
		name = [players objectAtIndex:1];
	else
		name = [players objectAtIndex:0];
	
	NSString *pushMessage = [NSString stringWithFormat:@"%@ has accepted your request to chat", [MGWU getUsername]];
	
	NSString *pubkey = [[NSUserDefaults standardUserDefaults] objectForKey:PUBLIC_TAG];
	NSMutableDictionary *gameData = [game objectForKey:@"gamedata"];
	[gameData setObject:pubkey forKey:[MGWU getUsername]];
	
	[MGWU move:@{} withMoveNumber:2 forGame:gameid withGameState:@"ended" withGameData:gameData againstPlayer:name withPushNotificationMessage:pushMessage withCallback:@selector(moveCompleted:) onTarget:self];
}

- (void)moveCompleted:(id)sender
{
	[self refresh];
}

- (void)reject:(id)sender
{
	int index = [(UIButton*)sender tag];
	NSDictionary *game = [gamesYourTurn objectAtIndex:index];
	int gameid = [[game objectForKey:@"gameid"] intValue];
	
	[MGWU deleteGame:gameid withCallback:@selector(gameDeleted:) onTarget:self];
}

- (void)gameDeleted:(id)sender
{
	[self refresh];
}

//When tableViewCell is tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *game = [games objectAtIndex:indexPath.row];
	FriendsTableViewCell *ftvc = (FriendsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
	
	ChatViewController *cvc = [[ChatViewController alloc] initWithFriend:ftvc.name.text];
	cvc.friendPubKey = [[game objectForKey:@"gamedata"] objectForKey:cvc.friendId];
	
	[self.navigationController pushViewController:cvc animated:YES];
	
	//Remove highlight on selected cell
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	//If transitioning to game, set the game depending on which cell was selected
    if([[segue identifier] isEqualToString:@"openChat"]){
		UITableViewCell *tvc = (UITableViewCell*)sender;
		NSIndexPath *indexPath = [tView indexPathForCell:tvc];
		
		NSDictionary *game = [gamesCompleted objectAtIndex:indexPath.row];
		
		ChatViewController *cvc = (ChatViewController *)[segue destinationViewController];
		cvc.friendId = tvc.textLabel.text;
		cvc.friendPubKey = [[game objectForKey:@"gamedata"] objectForKey:cvc.friendId];
	}
}

- (id)init
{
	self = [super init];
    if (self) {
        // Initialization code
		[self.view addSubview:[UIElements header:@"whisper" withBackButton:NO]];
		
		UIButton *new = [UIElements footerButtonWithTitle:@"new chat"];
		[new addTarget:self action:@selector(newChat:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:new];
		
		tView = [UIElements tableView];
		tView.delegate = self;
		tView.dataSource = self;
		[self.view addSubview:tView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	//Create Pull to Refresh
	pr = [[PullRefresh alloc] initWithDelegate:self];
	
	if ([MGWU getUsername])
	{
		usernameView.hidden = true;
		tView.hidden = false;
		newChat.hidden = false;
	}
	else
	{
		newChat.hidden = true;
		tView.hidden = true;
		usernameView.hidden = false;
		[usernameField setReturnKeyType:UIReturnKeySend];
		[usernameField setKeyboardAppearance:UIKeyboardAppearanceAlert];
		[usernameField setKeyboardType:UIKeyboardTypeAlphabet];
		[usernameField setDelegate:self];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:usernameField];
	}
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
