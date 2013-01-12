//
//  MenuViewController.h
//  Ghost
//
//  Created by Ashutosh Desai on 7/31/12.
//  Copyright (c) 2012 makegameswithus inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController
{
	//Buttons
	IBOutlet UIButton *play;
	IBOutlet UIButton *moreGames;
	//BOOL to keep track of whether the player is in the game (as opposed to in more games / how to play)
	BOOL inGame;
}

//IBAction for more games button
- (IBAction)moreGames:(id)sender;

@end
