//
//  SecondViewController.h
//  Ghost
//
//  Created by Ashutosh Desai on 7/11/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
//

#import <UIKit/UIKit.h>
#import "PullRefresh.h"

@interface PlayersViewController : UIViewController <UITextFieldDelegate, PullRefreshDelegate>
{
	//Table view to display players
	IBOutlet UITableView *tView;
	
	//Arrays for playing friends / recommended friends
	NSMutableArray *players;
	NSMutableArray *recommendedFriends;
	
	//Pull to refresh element
	PullRefresh *pr;
	
	//Counter of friends who just joined the game to show badge on tab bar
	int newFriends;
}

@property IBOutlet UITableView *tView;
@property PullRefresh *pr;
@property NSMutableArray *players, *recommendedFriends;
@property int newFriends;

- (IBAction)inviteFriends:(id)sender;

@end
