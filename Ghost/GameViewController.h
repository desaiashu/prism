//
//  GameViewController.h
//  Ghost
//
//  Created by Ashutosh Desai on 7/11/12.
//  Copyright (c) 2012 makegameswithus inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuessViewController.h"
#import "PopupViewController.h"

@interface GameViewController : UIViewController <GuessDelegate, PopupDelegate>
{
	//Dictionary containing game object
	NSMutableDictionary *game;
	//Username of opponenet
	NSString *opponent;
	//Variable to save whether the game is being created
	BOOL new;
	
	NSString *friendFullName;
	NSString *playerName;
	NSString *opponentName;
	
	IBOutlet UIBarButtonItem *chatButton;
	
	//Game specific UIElements
	IBOutlet UILabel *word;
	IBOutlet UILabel *player;
	IBOutlet UILabel *otherPlayer;
	IBOutlet UILabel *playerScore;
	IBOutlet UILabel *opponentScore;
	IBOutlet UILabel *lastResult;
	IBOutlet UILabel *lastWord;
	IBOutlet UILabel *vs;
	
	IBOutlet UIButton *play;
	IBOutlet UIButton *re;
	IBOutlet UIButton *define;
	IBOutlet UIButton *moreGames;
	IBOutlet UIView *divider;
	
	//Button to post on opponents wall
	IBOutlet UIButton *smackTalk;
	
	//Images to display profile pictures
	IBOutlet UIImageView *otherGuy;
	IBOutlet UIImageView *me;
		
	//Variable to control reloading of game
	BOOL inChat;
	BOOL inGuess;
	
	NSString *challengeReason;
	NSString *challengeOutcome;
	NSString *oldWord;
	
	NSString *title;
	
	GuessViewController *gvc;
	PopupViewController *pvc;
}

@property NSMutableDictionary *game;
@property NSString *opponent, *playerName, *opponentName;
@property BOOL inGuess;

- (void)loadGame;
- (void)quit;
- (void)refresh;
- (IBAction)moreGames:(id)sender;
- (IBAction)re:(id)sender;
- (IBAction)smackTalk:(id)sender;

@end
