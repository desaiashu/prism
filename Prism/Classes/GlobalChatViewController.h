//
//  ChatViewController.h
//  Ghost
//
//  Created by Ashutosh Desai on 8/19/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
//

#import <UIKit/UIKit.h>
#import "PullRefresh.h"

@interface GlobalChatViewController : UIViewController <UITextFieldDelegate>
{
	//Text entry box
	IBOutlet UITextField *message;
	//Array to save transcript of chat
	NSMutableArray *transcript;
	//Table View to display chat
	IBOutlet UITableView *tView;
	//Refresh button on the nav bar
	IBOutlet UIBarButtonItem *refreshButton;
}

@property UITableView* tView;

- (void)refresh;
- (IBAction)refresh:(id)sender;
- (IBAction)send:(id)sender;

@end
