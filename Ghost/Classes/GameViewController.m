//
//  GameViewController.m
//  Ghost
//
//  Created by Ashutosh Desai on 7/11/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
//

#import "GameViewController.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "DefinitionViewController.h"
#import "ProfilePictureCache.h"
#import "TabBarController.h"
#import "TableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Lexicontext.h"

@interface GameViewController ()

@end

@implementation GameViewController

@synthesize game, opponent, playerName, opponentName, inGuess;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		//When view is created, set inChat/inGuess to false
		inChat = false;
		inGuess = false;
		challengeReason = nil;
		challengeOutcome = nil;
		oldWord = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
	
	//Set chat button image to nothing
	[chatButton setImage:nil];
	//Set background image, cap insets are used for horizontal positioning
	UIImage *chatBtnImg = [[UIImage imageNamed:@"ChatButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 24, 0, 0)];
	[chatButton setBackgroundImage:chatBtnImg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	//Adjust vertical position
	[chatButton setBackgroundVerticalPositionAdjustment:4.0 forBarMetrics:UIBarMetricsDefault];
	//Adjust title position
	[chatButton setTitlePositionAdjustment:UIOffsetMake(2.0, 0) forBarMetrics:UIBarMetricsDefault];
	
	//The text on back buttons is by default the title of the previous view controller, we don't want text on the button, so this removes it. This actually controls the text on the back button for any view pushed on top of this view controller.
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	
	//Load the game
	[self loadGame];
	
	//Set labels to your and your opponents names, opponent name will be username if he is not your friend
	player.text = [TableViewCell shortName:[user objectForKey:@"name"]];
	otherPlayer.text = opponentName;
}

- (void)viewWillAppear:(BOOL)animated
{
	//Only reload the game if returning from chat view (since getMyInfo preloads all the games), and set chat button title to nothing since there are no unread chats
	if (inChat)
	{
		chatButton.title = @"";
		if ([[game objectForKey:@"turn"] isEqualToString:opponent])
			[MGWU getGame:[[game objectForKey:@"gameid"] intValue] withCallback:@selector(gotGame:) onTarget:self];
		inChat = false;
	}
	
	if (inGuess)
	{
		inGuess = false;
	}
}

- (void)openChat:(id)sender
{
	//Go to chat view when chat button tapped
	[self performSegueWithIdentifier:@"openChat" sender:chatButton];
}

- (void)gotGame:(NSMutableDictionary*)g
{
	//Update game object and reload game
	NSString *gameID = [NSString stringWithFormat:@"%@",[game objectForKey:@"gameid"]];
	
	//Prevent cheating by not reloading game if you challenged but haven't started the next round (since the server doesn't know about the challenge yet)
	NSMutableDictionary *savedGame = [NSMutableDictionary dictionaryWithDictionary:[MGWU objectForKey:gameID]];
	if ([savedGame isEqualToDictionary:@{}])
	{
		game = g;
		//If you're friends with the player, add friendName to the game dictionary
		if (friendFullName)
			[game setObject:friendFullName forKey:@"friendName"];
	}
	else
	{
		[game setObject:[g objectForKey:@"newmessages"] forKey:@"newmessages"];
	}
	
	//Update view
	[self loadGame];
}

- (void) loadGame
{
	//If game doesn't exist yet
	if (!game)
	{
		//Flag it as a new game, and set game specific variables to reflect a new game
		new = TRUE;
		word.text = @"";
		lastWord.text = @"";
		lastResult.text = @"";
		playerScore.text = @"";
		opponentScore.text = @"";
		[play setTitle:@"BEGIN GAME" forState:UIControlStateNormal];
		[play setHidden:NO];
		[re setHidden:YES];
		[define setHidden:YES];
		[moreGames setHidden:YES];
		[divider setHidden:YES];
		self.navigationItem.title = @"START";
	}
	//If game already exists
	else
	{
		//Flag it as a game in progress
		new = FALSE;
		
		NSString* gameState = [game objectForKey:@"gamestate"];
		NSString* turn = [game objectForKey:@"turn"];
		
		//Set opponent name from list of players
		NSArray* players = [game objectForKey:@"players"];
		if ([[players objectAtIndex:0] isEqualToString:[user objectForKey:@"username"]])
			opponent = [players objectAtIndex:1];
		else
			opponent = [players objectAtIndex:0];
		
		//Set opponent name and player name based on whether you're friends with your opponent, this is used for push notifications and round results
		if ([[game allKeys] containsObject:@"friendName"])
		{
			friendFullName = [game objectForKey:@"friendName"];
			opponentName = [TableViewCell shortName:friendFullName];
			playerName = [TableViewCell shortName:[user objectForKey:@"name"]];
		}
		else
		{
			opponentName = [opponent stringByReplacingOccurrencesOfString:@"_" withString:@"."];
			playerName = [[user objectForKey:@"username"] stringByReplacingOccurrencesOfString:@"_" withString:@"."];
		}
		
		//Set board to reflect gameData
		NSDictionary *gameData = [game objectForKey:@"gamedata"];
		
		playerScore.text = [[[gameData objectForKey:[user objectForKey:@"username"]] uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
		while ([playerScore.text length] < 5)
		{
			playerScore.text = [playerScore.text stringByAppendingString:@">"];
		}
		opponentScore.text = [[[gameData objectForKey:opponent] uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
		while ([opponentScore.text length] < 5)
		{
			opponentScore.text = [opponentScore.text stringByAppendingString:@">"];
		}
		
		lastWord.text = [gameData objectForKey:@"lastword"];
		lastResult.text = [gameData objectForKey:@"lastresult"];
		
		if ([[gameData objectForKey:@"lastdefinition"] isEqualToString:@""])
		{
			[divider setHidden:YES];
			[define setHidden:YES];
		}
		else
		{
			[divider setHidden:NO];
			[define setHidden:NO];
		}
		
		[moreGames setHidden:NO];
		
		//Based on state of game, set game specific variables
		if ([gameState isEqualToString:@"ended"])
		{
			if ([[gameData allKeys] containsObject:@"winner"])
			{
				if ([[gameData objectForKey:@"winner"] isEqualToString:opponent])
					word.text = [NSString stringWithFormat:@"%@ beat you", opponentName];
				else
					word.text = [NSString stringWithFormat:@"You beat %@", opponentName];
			}
			else
				word.text = [NSString stringWithFormat:@"Completed Game Against %@", opponentName];
			
			[play setHidden:YES];
			[re setTitle:@"REMATCH" forState:UIControlStateNormal];
			[re setHidden:NO];
			self.navigationItem.title = @"GAME OVER";
		}
		else if ([turn isEqualToString:opponent])
		{
			NSString *w = [gameData objectForKey:@"word"];
			word.text = w;
			[play setHidden:YES];
			[re setTitle:@"REFRESH" forState:UIControlStateNormal];
			[re setHidden:NO];
			self.navigationItem.title = @"WAITING...";
		}
		else
		{
			NSString *w = [gameData objectForKey:@"word"];
			if ([w isEqualToString:@""])
			{
				[play setTitle:@"BEGIN ROUND" forState:UIControlStateNormal];
				word.text = w;
			}
			else
			{
				[play setTitle:@"PLAY" forState:UIControlStateNormal];
				word.text = [NSString stringWithFormat:@"%@?", [w substringToIndex:[w length] - 1]];
			}

			[play setHidden:NO];
			[re setHidden:YES];
			self.navigationItem.title = @"YOUR TURN";
		}
		word.text = [word.text uppercaseString];
	
	}
	
	//Based on how many new messages, set chat button title
	if (game && [[game objectForKey:@"newmessages"] intValue] > 0)
		chatButton.title = [NSString stringWithFormat:@"%@", [game objectForKey:@"newmessages"]];
	else
		chatButton.title = @"";
}

- (void)quit
{
	//If player exits the app in the middle of guessing, treat it as a challenge
	[gvc challenge:nil];
}

- (void)guessed:(NSString *)letter
{
	//If the game is just starting
	if (!game)
	{
		//If the user left the app, do nothing
		if (!letter)
		{
			[self dismissModalViewControllerAnimated:YES];
			gvc = nil;
			return;
		}
		
		challengeReason = nil;
		challengeOutcome = nil;
		
		//Create the game on the server
		NSDictionary *move = @{@"letter":letter};
		
		NSDictionary *gameData = @{@"word":letter, [user objectForKey:@"username"]:@"", opponent:@"", @"lastword":@"", @"lastresult":@"", @"lastdefinition":@""};
		
		NSString *pushMessage = [NSString stringWithFormat:@"%@ began a game with you", playerName];
		
		//move is a custom dictionary (see above)
		//moveNumber is 0
		//gameID is 0
		//gameState is @"started"
		//gameData is a custom dictionary (see above)
		//opponent is the username of the opponent
		//pushMessage is a custom string (see above)
		[MGWU move:move withMoveNumber:0 forGame:0 withGameState:@"started" withGameData:gameData againstPlayer:opponent withPushNotificationMessage:pushMessage withCallback:@selector(moveCompleted:) onTarget:self];
		
		[MGWU logEvent:@"began_game" withParams:@{@"letter":letter}];
		
	}
	//Else if the game is in progress
	else
	{
		NSDictionary *oldGameData = [game objectForKey:@"gamedata"];
		int gameID = [[game objectForKey:@"gameid"] intValue];
		
		//If it is a challenge
		if (!letter)
		{
			NSString *challengedWord = [[oldGameData objectForKey:@"word"] stringByReplacingOccurrencesOfString:@" " withString:@""];
			
			//Remember the challenged word
			oldWord = challengedWord;
			
			if ([challengedWord length] < 2)
			{
				[self dismissModalViewControllerAnimated:YES];
				gvc = nil;
				return;
			}
			
			//Find a word that begins with the challenged fragment
			NSString *w = [self getWordWithPrefix:challengedWord];
			
			NSString *username = [user objectForKey:@"username"];
			
			BOOL ended = FALSE;
			NSDictionary *gameData;
			
			//If no word exists, the challenge was won, update the game data to reflect this, and update the challenge reason and outcome
			if (!w)
			{
				NSString *oldscore = [oldGameData objectForKey:opponent];
				NSString *score = [self incrementScore:oldscore];
				if ([score isEqualToString:@"ghost"])
				{
					gameData = @{@"winner":username, username:[oldGameData objectForKey:username], opponent:score, @"lastword":challengedWord, @"lastresult":[NSString stringWithFormat:@"%@ won last round", playerName], @"lastdefinition":[NSString stringWithFormat:@"%@ (not a word, nor a word fragment)", challengedWord]};
					ended = TRUE;
				}
				else
				{
					gameData = @{@"word":@"", username:[oldGameData objectForKey:username], opponent:score, @"lastword":challengedWord, @"lastresult":[NSString stringWithFormat:@"%@ won last round", playerName], @"lastdefinition":[NSString stringWithFormat:@"%@ (not a word, nor a word fragment)", challengedWord]};
				}
				challengeReason = @"not_word";
				challengeOutcome = @"won";
			}
			//If the fragment is a complete word, the challenge was won, update the game data to reflect this, and update the challenge reason and outcome
			else if ([w isEqualToString:challengedWord])
			{
				NSString *oldscore = [oldGameData objectForKey:opponent];
				NSString *score = [self incrementScore:oldscore];
				if ([score isEqualToString:@"ghost"])
				{
					gameData = @{@"winner":username, username:[oldGameData objectForKey:username], opponent:score, @"lastword":challengedWord, @"lastresult":[NSString stringWithFormat:@"%@ won last round", playerName], @"lastdefinition":[[Lexicontext sharedDictionary] definitionFor:w]};
					ended = TRUE;
				}
				else
				{
					gameData = @{@"word":@"", username:[oldGameData objectForKey:username], opponent:score, @"lastword":challengedWord, @"lastresult":[NSString stringWithFormat:@"%@ won last round", playerName], @"lastdefinition":[[Lexicontext sharedDictionary] definitionFor:w]};
				}
				challengeReason = @"complete_word";
				challengeOutcome = @"won";
			}
			//If the fragment is not a complete word, but is the start of another word, the challenge was lost, update the game data to reflect this, and update the challenge reason and outcome
			else
			{
				NSString *oldscore = [oldGameData objectForKey:[user objectForKey:@"username"]];
				NSString *score = [self incrementScore:oldscore];
				if ([score isEqualToString:@"ghost"])
				{
					gameData = @{@"winner":opponent, username:score, opponent:[oldGameData objectForKey:opponent], @"lastword":[NSString stringWithFormat:@"%@ (%@)", challengedWord, w], @"lastresult":[NSString stringWithFormat:@"%@ won last round", opponentName], @"lastdefinition":[[Lexicontext sharedDictionary] definitionFor:w]};
					ended = TRUE;
				}
				else
				{
					gameData = @{@"word":@"", username:score, opponent:[oldGameData objectForKey:opponent], @"lastword":[NSString stringWithFormat:@"%@ (%@)", challengedWord, w], @"lastresult":[NSString stringWithFormat:@"%@ won last round", opponentName], @"lastdefinition":[[Lexicontext sharedDictionary] definitionFor:w]};
				}
				challengeReason = @"unknown";
				challengeOutcome = @"lost";
			}
			
			NSString *gameEnded;
			
			//If the game was ended
			if (ended)
			{
				//Send the move up to the server and end the game
				NSDictionary *move = @{@"challenge":challengedWord};

				int moveNumber = [[game objectForKey:@"movecount"] intValue] + 1;
				
				NSString *gameState = @"ended";
				
				NSString *pushMessage;
				
				if ([[gameData objectForKey:@"winner"] isEqualToString:opponent])
				{
					pushMessage = [NSString stringWithFormat:@"You beat %@! :)", playerName];
				}
				else
				{
					pushMessage = [NSString stringWithFormat:@"%@ beat you! :(", playerName];
				}
				
				//move is a custom dictionary (see above)
				//moveNumber is incremented from the old move number
				//gameID is the same as the old gameID
				//gameState is @"ended"
				//gameData is a custom dictionary (see above)
				//opponent is the username of the opponent
				//pushMessage is a custom string (see above)
				[MGWU move:move withMoveNumber:moveNumber forGame:gameID withGameState:gameState withGameData:gameData againstPlayer:opponent withPushNotificationMessage:pushMessage withCallback:@selector(moveCompleted:) onTarget:self];
				
				gameEnded = @"yes";
			}
			//Otherwise, update the gameData and save it to prevent cheating, but don't send anything up to the server since you need to begin the next round
			else
			{
				[game setObject:gameData forKey:@"gamedata"];
				NSString *gameID = [NSString stringWithFormat:@"%@",[game objectForKey:@"gameid"]];
				[MGWU setObject:game forKey:gameID];
				[self loadGame];
				gameEnded = @"no";
			}
			
			//open graph magic
			if ([challengeOutcome isEqualToString:@"won"])
			{
				NSString *opUsername = [opponent stringByReplacingOccurrencesOfString:@"_" withString:@"."];
				NSString *u = [NSString stringWithFormat: @"https://graph.facebook.com/%@/picture", opUsername];
				NSDictionary *params;
				if ([[game allKeys] containsObject:@"friendName"])
					params = @{@"object":@"profile", @"title":[game objectForKey:@"friendName"], @"username":opUsername, @"image":u};
				else
					params = @{@"object":@"profile", @"title":opUsername, @"username":opUsername, @"image":u};
				[MGWU publishOpenGraphAction:@"beat" withParams:params];
				
				int roundswon = [[[NSUserDefaults standardUserDefaults] objectForKey:@"totalroundswon"] intValue];
				roundswon += 1;
				[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:roundswon] forKey:@"totalroundswon"];
				[MGWU publishOpenGraphAction:@"highscore" withParams:@{@"score":[NSNumber numberWithInt:roundswon]}];
			}
			
			NSDictionary *params = @{@"object":@"word", @"title":challengedWord, @"word":challengedWord, @"description":[gameData objectForKey:@"lastdefinition"], @"image":@"https://s3.amazonaws.com/mgwu-app-icons/com_mgwu_gg@2x.png"};
			[MGWU publishOpenGraphAction:@"challenge" withParams:params];
			
			[MGWU logEvent:@"challenge" withParams:@{@"reason":challengeReason, @"result":challengeOutcome, @"word":challengedWord, @"word_length":[NSNumber numberWithInt:[challengedWord length]], @"game_ended":gameEnded}];
		}
		//If not a challenge
		else
		{
			challengeOutcome = nil;
			challengeReason = nil;
			
			oldWord = [oldGameData objectForKey:@"word"];
			
			//Send move up to the server
			NSDictionary *move;
			if ([oldWord isEqualToString:@""])
			{
				move = @{@"challenge":[oldGameData objectForKey:@"lastword"], @"letter":letter};
				[MGWU logEvent:@"began_round" withParams:@{@"letter":letter}];
			}
			else
				move = @{@"letter":letter};
			
			int moveNumber = [[game objectForKey:@"movecount"] intValue] + 1;
			
			NSString *gameState = @"inprogress";
			
			NSString *w;
			
			if ([oldWord isEqualToString:@""])
				w = letter;
			else
				w = [NSString stringWithFormat:@"%@ %@", oldWord, letter];
			
			NSMutableDictionary *gameData = [NSMutableDictionary dictionaryWithDictionary:oldGameData];
			[gameData setObject:w forKey:@"word"];
			
			NSString *pushMessage;
		
			pushMessage = [NSString stringWithFormat:@"%@ played you, go play now!", playerName];
		
			//move is a custom dictionary (see above)
			//moveNumber is incremented from the old move number
			//gameID is the same as the old gameID
			//gameState is @"inprogress"
			//gameData is a custom dictionary (see above)
			//opponent is the username of the opponent
			//pushMessage is a custom string (see above)
			[MGWU move:move withMoveNumber:moveNumber forGame:gameID withGameState:gameState withGameData:gameData againstPlayer:opponent withPushNotificationMessage:pushMessage withCallback:@selector(moveCompleted:) onTarget:self];
		}
	}
	//Dismiss the guess view controller and show the challenge popup
	[self dismissViewControllerAnimated:YES completion:^(void)
	 {
		 [self displayChallengePopup];
	 }];
	gvc = nil;
	
	if (letter)
		[MGWU logEvent:@"letter_selected" withParams:@{@"letter":letter}];
}

- (void)displayChallengePopup
{
	//If there was a challenge (so challenge reason won't be nil), display a popup showing the result of the challenge
	if (challengeReason)
	{
		pvc = (PopupViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"popup"];
		if ([challengeOutcome isEqualToString:@"won"])
			pvc.titleString = @"You Won the Challenge!";
		else
			pvc.titleString = @"You Lost the Challenge";
		if ([challengeReason isEqualToString:@"not_word"])
			pvc.messageString = [NSString stringWithFormat:@"%@ is not a word, nor a word fragment", oldWord];
		else if ([challengeReason isEqualToString:@"complete_word"])
			pvc.messageString = [NSString stringWithFormat:@"%@ is a complete word", oldWord];
		else
			pvc.messageString = [NSString stringWithFormat:@"%@ is not a word, but is a word fragment", oldWord];
		pvc.delegate = self;
		[self.view addSubview:pvc.view];
	}

}

-(void)dismiss
{
	//Dismiss the challenge outcome popup
	[pvc.view removeFromSuperview];
	pvc = nil;
}

- (NSString*)getWordWithPrefix:(NSString*)prefix
{
	//First check if the fragment is longer than 3 letters and exists in the dictionary, if so, return the word
	if ([prefix length] > 3 && [[Lexicontext sharedDictionary] containsDefinitionFor:prefix])
		return prefix;
	
	//Otherwise, cycle through the words that begin with the fragment and return the first one you find
	NSDictionary *d = [[Lexicontext sharedDictionary] wordsWithPrefix:prefix];
	
	for (NSString *key in [d allKeys])
	{
		NSArray *a = [d objectForKey:key];
		for (NSString *st in a)
		{
			NSString *noParen = [[st componentsSeparatedByString:@" ("] objectAtIndex:0];
			NSCharacterSet *nonLetters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"] invertedSet];
			NSString *onlyLetters = [[noParen componentsSeparatedByCharactersInSet:nonLetters] objectAtIndex:0];
			if ([noParen length] > 3 &&
				[noParen length] == [onlyLetters length])
				return onlyLetters;
		}
	}
	
	//If no words were found, return nil
	return nil;
}

//Increment the score string that is passed in by adding a letter
- (NSString*)incrementScore:(NSString*)oldScore
{
	oldScore = [oldScore stringByReplacingOccurrencesOfString:@" " withString:@""];
	if ([oldScore isEqualToString:@""])
		return @"g";
	else if ([oldScore isEqualToString:@"g"])
		return @"gh";
	else if ([oldScore isEqualToString:@"gh"])
		return @"gho";
	else if ([oldScore isEqualToString:@"gho"])
		return @"ghos";
	else if ([oldScore isEqualToString:@"ghos"])
		return @"ghost";
	else
		return @"";
}

- (IBAction)moreGames:(id)sender
{
	//Display cross promo when more games is tapped
	[MGWU displayCrossPromo];
}

- (void)refresh
{
	//If game object exists, reload the game
	if (game)
	{
		[MGWU getGame:[[game objectForKey:@"gameid"] intValue] withCallback:@selector(gotGame:) onTarget:self];
	}
		
}

//Action to refresh the game, or start a rematch
- (IBAction)re:(id)sender
{
	//If it is not your turn, refresh the game
	if ([[[re titleLabel] text] isEqualToString:@"REFRESH"])
	{
		[self refresh];
		return;
	}
	//If the game is over, start a new game
	else if ([[[re titleLabel] text] isEqualToString:@"REMATCH"])
	{
		game = nil;
		[self loadGame];
		return;
	}
}

- (void)moveCompleted:(NSMutableDictionary*)newGame
{
	//Refresh the game once a move has been made
	game = newGame;
	[self loadGame];
	
	//Remove the opponent from the list of players in case you just started a new game
	[[[(TabBarController*)self.tabBarController pvc] players] removeObject:opponent];
	
	//Remove the saved version of the game
	NSString *gameID = [NSString stringWithFormat:@"%@",[game objectForKey:@"gameid"]];
	[MGWU removeObjectForKey:gameID];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	//If you're opening the chat view, set the opponent before the segue
    if([[segue identifier] isEqualToString:@"openChat"]){
		ChatViewController *cvc = (ChatViewController*)[segue destinationViewController];
		cvc.friendId = opponent;
		inChat = true;
	}
	//Else if you're opening the guess view, set the word and set the delegate before the segue
	else if ([[segue identifier] isEqualToString:@"openGuess"]){
		gvc = (GuessViewController*)[segue destinationViewController];
		gvc.delegate = self;
		if (game)
			gvc.w = [[game objectForKey:@"gamedata"] objectForKey:@"word"];
		else
			gvc.w = @"";
		inGuess = true;
	}
	//Else if you're opening the definition view controller, set the definition before the segue
	else if ([[segue identifier] isEqualToString:@"showDefinition"]){
		DefinitionViewController *dvc = (DefinitionViewController*)[segue destinationViewController];
		dvc.definition = [[game objectForKey:@"gamedata"] objectForKey:@"lastdefinition"];
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
