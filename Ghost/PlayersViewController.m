//
//  SecondViewController.m
//  Ghost
//
//  Created by Ashutosh Desai on 7/11/12.
//  Copyright (c) 2012 makegameswithus inc. All rights reserved.
//

#import "PlayersViewController.h"
#import "AppDelegate.h"
#import "GameViewController.h"
#import "TabBarController.h"
#import "ProfilePictureCache.h"
#import "TableViewCell.h"

@interface PlayersViewController ()

@end

@implementation PlayersViewController

@synthesize tView, pr, players, recommendedFriends, newFriends;

- (void)viewWillAppear:(BOOL)animated
{
	//Set nav bar title
	self.tabBarController.navigationItem.title = @"NEW GAME";
	
	//Set new friends to 0 and set badge value to nil (when the view is being shown these are reset)
	int diff = [self.tabBarItem.badgeValue intValue];
	newFriends = 0;
	self.tabBarItem.badgeValue = nil;
	int numFriends = [[NSUserDefaults standardUserDefaults] integerForKey:@"numFriends"]+diff;
	[[NSUserDefaults standardUserDefaults] setInteger:numFriends forKey:@"numFriends"];
}

- (void)refresh
{
	//Refresh tabBarController to reload games
	[(TabBarController*)self.tabBarController refresh];
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

- (IBAction)inviteFriends:(id)sender
{
	[self.tabBarController setSelectedIndex:2];
}

//Three sections in table view, first section has random buttons, then recommended friends, then all friends
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return 0.0;
	else
		return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section == 0)
	{
		UIView *b = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 310, 2)];
		b.backgroundColor = [UIColor colorWithRed:(223.0/256.0) green:(228.0/256.0) blue:(227.0/256.0) alpha:1.0];
		return b;
	}
	UIView *t = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	
	UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HeaderBackground"]];
	
	UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 28)];
	l.textColor = [UIColor colorWithRed:(223.0/256.0) green:(228.0/256.0) blue:(227.0/256.0) alpha:1.0];
	l.font = [UIFont fontWithName:@"Nexa Bold" size:28.0];
	l.backgroundColor = [UIColor clearColor];
	if (section == 0)
		l.text = @"RANDOM PLAYERS";
	else if (section == 1)
		l.text = @"RECOMMENDED";
	else
		l.text = @"ALL FRIENDS";
	
	UIView *b = [[UIView alloc] initWithFrame:CGRectMake(5, 32, 310, 2)];
	b.backgroundColor = [UIColor colorWithRed:(223.0/256.0) green:(228.0/256.0) blue:(227.0/256.0) alpha:1.0];
	
	[t addSubview:v];
	[t addSubview:l];
	[t addSubview:b];
	
	return t;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return @"Begin Game With:";
	else if (section == 1)
		return @"Recommended Friends";
	else
		return @"All Friends";
}

//Set number of rows based on sections, first section will have 2, next two depend on arrays
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0)
		return 2;
	else if (section == 1)
		return [recommendedFriends count];
	else
		return [players count];
}

//The sectionIndexTitles are for the scroll bar on the right (such as in the iPod app), only kick into gear if you have more than 20 friends playing the app
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *charactersForSort = [[NSMutableArray alloc] init];
	
	[charactersForSort addObject:@"#"];
	for (NSDictionary *item in players)
	{
		if (![charactersForSort containsObject:[[item valueForKey:@"name"] substringToIndex:1]])
		{
			[charactersForSort addObject:[[item valueForKey:@"name"] substringToIndex:1]];
		}
	}
	return charactersForSort;
}

//Allows you to use the scroll bar on the right to scroll to a letter
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([title isEqualToString:@"#"])
		[tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	else
	{
		BOOL found = NO;
		NSInteger b = 0;
		for (NSDictionary *item in players)
		{
			if ([[[item valueForKey:@"name"] substringToIndex:1] isEqualToString:title])
				if (!found)
				{
					[tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:b inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
					found = YES;
				}
			b++;
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [TableViewCell cellHeight];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Create cell based on section (the different CellIdentifiers are connected to different segue's in the storyboard)
	static NSString *CellIdentifier;
	if (indexPath.section == 0)
		CellIdentifier = @"RandomCell";
	else if (indexPath.section == 1)
		CellIdentifier = @"RecommendedCell";
	else
		CellIdentifier = @"Cell";
	
	TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[TableViewCell alloc]
				initWithStyle:UITableViewCellStyleValue1
				reuseIdentifier:CellIdentifier];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	
	//Set name and action based on cell
	NSString *name;
	NSString *action = @"Play";
	//First section has random friend and random player
	if (indexPath.section == 0)
	{
		if (indexPath.row == 0)
		{
			cell.imageView.image = [UIImage imageNamed:@"RedGhost.png"];
			name = @"Random Friend";
		}
		else
		{
			cell.imageView.image = [UIImage imageNamed:@"WhiteGhost.png"];
			name = @"Random";
		}
	}
	//Second section has recommended friends, using play or invite depending on whether the friend plays the game
	else if (indexPath.section == 1)
	{
		cell.imageView.image = [UIImage imageNamed:@"WhiteGhost.png"];
		name = [[recommendedFriends objectAtIndex:indexPath.row] objectForKey:@"name"];
		name = [TableViewCell shortName:name];
		NSString *uname = [[recommendedFriends objectAtIndex:indexPath.row] objectForKey:@"username"];
		[ProfilePictureCache setProfilePicture:uname forImageView:cell.imageView inTableView:tableView forIndexPath:indexPath];
		if (indexPath.row == 2 || indexPath.row >= [players count])
			action = @"Invite!";
	}
	//Third section has friends who play the game
	else
	{
		cell.imageView.image = [UIImage imageNamed:@"WhiteGhost.png"];
		name = [[players objectAtIndex:indexPath.row] objectForKey:@"name"];
		name = [TableViewCell shortName:name];
		NSString *uname = [[players objectAtIndex:indexPath.row] objectForKey:@"username"];
		[ProfilePictureCache setProfilePicture:uname forImageView:cell.imageView inTableView:tableView forIndexPath:indexPath];
	}
	
	//Set text of name and action
	cell.textLabel.text = name;
	cell.detailTextLabel.text = action;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//For random section
	if (indexPath.section == 0)
	{
		//If random friend, start a game with a random available friend
		if (indexPath.row == 0)
		{
			if ([players count] < 1)
				[MGWU showMessage:@"Already playing with all friends" withImage:nil];
			else
			{
				int i = arc4random()%[players count];
				GameViewController *gvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
				gvc.opponent = [[players objectAtIndex:i] objectForKey:@"username"];
				gvc.opponentName = [TableViewCell shortName:[[players objectAtIndex:i] objectForKey:@"name"]];
				gvc.playerName = [TableViewCell shortName:[user objectForKey:@"name"]];
				[self.navigationController pushViewController:gvc animated:YES];
			}
		}
		//If random player, load random player from the server, callback will begin game
		else
			[MGWU getRandomPlayerWithCallback:@selector(gotPlayer:) onTarget:self];
	}
	//If recommended friend, start a game with the friend
	else if (indexPath.section == 1)
	{
		//If it's a friend who isn't playing, invite them on facebook
		if (indexPath.row == 2 || indexPath.row >= [players count])
			[MGWU inviteFriend:[[recommendedFriends objectAtIndex:indexPath.row] objectForKey:@"username"] withMessage:@"Play a game with me!"];
		GameViewController *gvc = (GameViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
		gvc.opponent = [[recommendedFriends objectAtIndex:indexPath.row] objectForKey:@"username"];
		gvc.opponentName = [TableViewCell shortName:[[recommendedFriends objectAtIndex:indexPath.row] objectForKey:@"name"]];
		gvc.playerName = [TableViewCell shortName:[user objectForKey:@"name"]];
		[self.navigationController pushViewController:gvc animated:YES];
	}
	//Remove highlight from selected cell
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(IBAction)search:(id)sender
{
	//Hide keyboard and search for player with username, callback begins a game with the player
	[searchbox resignFirstResponder];
	[MGWU getPlayerWithUsername:searchbox.text withCallback:@selector(gotPlayer:) onTarget:self];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
	//Hide keyboard when done clicked
    [textField resignFirstResponder];
    return YES;
}

-(void)gotPlayer:(NSDictionary*)p
{
	//If player doesn't exist (no player of that username), do nothing
	if (!p)
		return;

	//Start game with player
    GameViewController *gvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
	gvc.opponent = [p objectForKey:@"username"];
	//FIX THIS LATER TO CHECK IF USER IS FRIEND
	gvc.opponentName = [p objectForKey:@"username"];
	gvc.playerName = [user objectForKey:@"username"];
	[self.navigationController pushViewController:gvc animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	//If transitioning to game from list of players, start game with the player
    if([[segue identifier] isEqualToString:@"beginGame"]){
		UITableViewCell *tvc = (UITableViewCell*)sender;
		NSIndexPath *indexPath = [tView indexPathForCell:tvc];
		GameViewController *gvc = (GameViewController *)[segue destinationViewController];
		gvc.opponent = [[players objectAtIndex:indexPath.row] objectForKey:@"username"];
		gvc.opponentName = [TableViewCell shortName:[[players objectAtIndex:indexPath.row] objectForKey:@"name"]];
		gvc.playerName = [TableViewCell shortName:[user objectForKey:@"name"]];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	//Set properties of searchbox
	searchbox.delegate = self;
	[searchbox setReturnKeyType:UIReturnKeyDone];
	[searchbox setAutocorrectionType:UITextAutocorrectionTypeNo];
	[searchbox setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	
	//If app is in landscape orientation and device is iPhone 5, expand searchbox
	if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) && self.view.frame.size.height == 568) //Since rotation is not done until viewDidAppear
		searchbox.frame = CGRectMake(searchbox.frame.origin.x, searchbox.frame.origin.y, searchbox.frame.size.width+88, searchbox.frame.size.height);
	
	//Create pull to refresh element
	pr = [[PullRefresh alloc] initWithDelegate:self];
	
	if ([tView respondsToSelector:@selector(setSectionIndexColor:)])
	{
		// In iOS 6 there is a own method available to set the index color
		[tView setSectionIndexColor:[UIColor whiteColor]];
	}
	else
	{
		// Use this hack in previous iOS releases
		for(UIView *view in [tView subviews])
			if([view respondsToSelector:@selector(setIndexColor:)])
				[view performSelector:@selector(setIndexColor:) withObject:[UIColor whiteColor]];
	}
	
	//Only show section index (letter scroll bar on right) if you have 20+ rows
	tView.sectionIndexMinimumDisplayRowCount = 20;
		
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
