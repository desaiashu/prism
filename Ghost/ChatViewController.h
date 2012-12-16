//
//  ChatViewController.h
//  Ghost
//
//  Created by Ashutosh Desai on 8/19/12.
//  Copyright (c) 2012 makegameswithus inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefresh.h"

@interface ChatViewController : UIViewController <UITextFieldDelegate>
{
	//Text entry box
	IBOutlet UITextField *message;
	//Username of user to chat with
	NSString* friendId;
	//Array to save transcript of chat
	NSMutableArray *transcript;
	//Table View to display chat
	IBOutlet UITableView *tView;
	
	IBOutlet UIBarButtonItem *refreshButton;
}

@property NSString* friendId;
@property UITableView* tView;

- (void)refresh;
- (IBAction)refresh:(id)sender;
- (IBAction)send:(id)sender;

@end
