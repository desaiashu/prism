//
//  SecondViewController.m
//  Ghost
//
//  Created by Ashutosh Desai on 7/11/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
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
	//When invite friends is clicked, navigate to the third tab, this button is included so it is obvious to the user how to invite friends if he doesn't explore the tabs
	[self.tabBarController setSelectedIndex:2];
}

//Three sections in table view, first section has random buttons, then recommended friends, then all friends
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

//Set height of section headers, no header on the top section
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return 0.0;
	else
		return 40.0;
}

//Customize look of section header, give it background, line, custom fonts and set the title based on which section it is
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section == 0)
	{
		return nil;
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

//The sectionIndexTitles are for the scroll bar on the right (such as in the iPod app), only kicks into gear if you have more than 20 friends playing the app (see viewDidLoad method)
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

//Since our cells are custom cells, we need to return the height of each row
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
	
	//Create cell as TableViewCell, our custom cell class
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
	//First section has random friend and random player, set their images to the red and white ghosts
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

//When tableViewCell is tapped
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
		//Get random game from server, callback will begin game
		else
			[MGWU getRandomGameWithCallback:@selector(gotGame:) onTarget:self];
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

-(void)gotGame:(NSMutableDictionary*)g
{
	//If error occurs, do nothing
	if (!g)
		return;
	
	//If the server responds with no existing random game, start a new one
	if ([[g objectForKey:@"gameid"] intValue] == 0)
	{
		//Start game with mgwu-random
		GameViewController *gvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
		gvc.opponent = @"mgwu-random";
		gvc.opponentName = @"mgwu-random";
		gvc.playerName = [user objectForKey:@"username"];
		[self.navigationController pushViewController:gvc animated:YES];
	}
	//Otherwise, join the game that was returned
	else
	{
		//Play game retreived from server
		GameViewController *gvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
		gvc.game = g;
		[self.navigationController pushViewController:gvc animated:YES];
	}
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
	
	//Create pull to refresh element
	pr = [[PullRefresh alloc] initWithDelegate:self];
	
	if ([tView respondsToSelector:@selector(setSectionIndexColor:)])
	{
		// In iOS 6 there is a method available to set the index color
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
