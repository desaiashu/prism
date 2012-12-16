//
//  TabBarController.h
//  Ghost
//
//  Created by Ashutosh Desai on 9/3/12.
//  Copyright (c) 2012 makegameswithus inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GamesViewController.h"
#import "PlayersViewController.h"
#import "InviteViewController.h"

@interface TabBarController : UITabBarController <UIAlertViewDelegate>
{
	//References to all the views within the tab view controller
	GamesViewController *gvc;
	PlayersViewController *pvc;
	InviteViewController *ivc;
	
	UIAlertView *updateAlertView;
	NSString *updateURL;
	int counter;
}

@property PlayersViewController *pvc;

- (void)refresh;

@end
