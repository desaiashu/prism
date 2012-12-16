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
	BOOL inCrossPromo;
	IBOutlet UIButton *play;
	IBOutlet UIButton *moreGames;
	BOOL inInstructions;
	long long timestamp;
}

- (IBAction)moreGames:(id)sender;

@end
