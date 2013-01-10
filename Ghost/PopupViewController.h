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
	NSString *titleString;
	NSString *messageString;
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *messageLabel;
	id<PopupDelegate> delegate;
}

@property NSString *titleString, *messageString;
@property id<PopupDelegate> delegate;

@end
