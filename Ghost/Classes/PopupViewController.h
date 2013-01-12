//
//  PopupViewController.h
//  Ghost
//
//  Created by Ashutosh Desai on 1/9/13.
//  Copyright (c) 2013 makegameswithus inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopupDelegate <NSObject>

-(void)dismiss;

@end

@interface PopupViewController : UIViewController
{
	//Strings to be set after initializing
	NSString *titleString;
	NSString *messageString;
	
	//Labels
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *messageLabel;
	
	//Delegate to dismiss popup
	id<PopupDelegate> delegate;
}

@property NSString *titleString, *messageString;
@property id<PopupDelegate> delegate;

@end
