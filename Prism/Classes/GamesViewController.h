//
//  FirstViewController.h
//  Ghost
//
//  Created by Ashutosh Desai on 7/11/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
//

#import <UIKit/UIKit.h>
#import "PullRefresh.h"

@interface GamesViewController : UIViewController <PullRefreshDelegate, UITextFieldDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
	//Arrays to store games based on status
	NSMutableArray *games;
	NSMutableArray *gamesYourTurn;
	NSMutableArray *gamesTheirTurn;
	NSMutableArray *gamesCompleted;
	
	//Table view to display games
	IBOutlet UITableView *tView;
	
	IBOutlet UIView *usernameView;
	IBOutlet UITextField *usernameField;
	IBOutlet UIButton *newChat;
	
	//Pull to refresh element
	PullRefresh *pr;
	
	//Variables for update prompt
	UIAlertView *updateAlertView;
	NSString *updateURL;
}

@property NSMutableArray *games, *gamesYourTurn, *gamesTheirTurn, *gamesCompleted;
@property UITableView *tView;
@property PullRefresh *pr;

- (void)refresh;
- (IBAction)go:(id)sender;

@end
