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
	IBOutlet UIButton *play;
	IBOutlet UIButton *moreGames;
	BOOL inGame;
}

- (IBAction)moreGames:(id)sender;

@end
