//
//  ChatViewController.m
//  Ghost
//
//  Created by Ashutosh Desai on 8/19/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
//

#import "ChatViewController.h"
#import "AppDelegate.h"
#import "Security.h"
#include <mach/mach_time.h>
#include <stdint.h>

@interface ChatViewController ()

@end

@implementation ChatViewController

@synthesize friendId, friendPubKey, tView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		//Initialize the array to empty
		transcript = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithFriend:(NSString*)f andPubKey:(NSString*)p
{
    self = [super init];
    if (self) {
        // Custom initialization
		self.view.backgroundColor = [UIElements backgroundColor];
		
		//Initialize the array to empty
		transcript = [[NSMutableArray alloc] init];
		friendId = f;
		friendPubKey = p;
		[self.view addSubview:[UIElements header:friendId withBackButton:YES]];
		tView = [UIElements tableView];
		tView.delegate = self;
		tView.dataSource = self;
		[self.view addSubview:tView];
		footer = [UIElements footer];
		message = [UIElements footerTextInputField];
		send = [UIElements sendButton];
		[send addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
		[footer addSubview:message];
		[footer addSubview:send];
		[self.view addSubview:footer];
		
		//Set variables for text entry field
		[message setKeyboardAppearance:UIKeyboardAppearanceAlert];
		[message setDelegate:self];
		
		editing = FALSE;
		
		[Security addPeerPublicKey:friendId keyString:friendPubKey];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
	//Get messages from server
	[MGWU getMessagesWithFriend:friendId andCallback:@selector(reload:) onTarget:self];
}

- (void)viewWillAppear:(BOOL)animated {
	
	//Register to get alerts when the keyboard is about to appear or hide
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification object:self.view.window];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification object:self.view.window];
	
//	//If push notifications are disabled, alert the user that the chat won't be live
//	if (noPush)
//		[MGWU showMessage:@"Turn on Push Notifications in Settings for live chat" withImage:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	//Unregister for alerts
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)textViewDidChange:(UITextView *)textView
{
	if (textView.contentSize.height != textView.frame.size.height)
	{
		int oldHeight = textView.frame.size.height;
		int newHeight = textView.contentSize.height;
		if (newHeight < 36)
			newHeight = 36;
		if (newHeight > 36+tView.frame.size.height)
			newHeight = 36+tView.frame.size.height;
		int delta = newHeight - oldHeight;
		if (delta != 0)
		{
			textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height+delta);
			send.frame = CGRectMake(send.frame.origin.x, send.frame.origin.y+delta, send.frame.size.width, send.frame.size.height);
			footer.frame = CGRectMake(footer.frame.origin.x, footer.frame.origin.y-delta, footer.frame.size.width, footer.frame.size.height+delta);
		}
	}
}

- (IBAction)refresh:(id)sender
{
	//Hide Keyboard then reload chat, using button instead of pull to refresh because of layout of chat
	[message resignFirstResponder];
	[MGWU getMessagesWithFriend:friendId andCallback:@selector(reload:) onTarget:self];
}

- (void)refresh
{
	//Hide Keyboard then reload chat
	[message resignFirstResponder];
	[MGWU getMessagesWithFriend:friendId andCallback:@selector(reload:) onTarget:self];
}

- (void)reload:(NSMutableArray*)t
{
	if (!t)
		return;
	
	//Update transcript and reload the table view
	transcript = t;
	
	//Decrypt messages
	//const uint64_t startTime = mach_absolute_time();
	// Do some stuff that you want to time
	dispatch_apply([transcript count], dispatch_get_global_queue(0, 0), ^(size_t i){
		NSString *body = [[transcript objectAtIndex:i] objectForKey:@"message"];
		NSArray *messageParts = [body componentsSeparatedByString:@"|"];
		
		if ([[[transcript objectAtIndex:i] objectForKey:@"from"] isEqualToString:[user objectForKey:@"username"]])
			body = [Security decryptRSA:[messageParts objectAtIndex:0]];
		else
			body = [Security decryptRSA:[messageParts objectAtIndex:1]];
		
		if (!body || [body isEqualToString:@""])
			body = @"this message could not be decrypted";
		
		[[transcript objectAtIndex:i] setObject:body forKey:@"message"];
    });
//	const uint64_t endTime = mach_absolute_time();
//	
//	// Time elapsed in Mach time units.
//	const uint64_t elapsedMTU = endTime - startTime;
//	
//	// Get information for converting from MTU to nanoseconds
//	mach_timebase_info_data_t info;
//	mach_timebase_info(&info);
//		//handleErrorConditionIfYoureBeingCareful();
//	
//	// Get elapsed time in nanoseconds:
//	double elapsedNS = (double)elapsedMTU * (double)info.numer / (double)info.denom;
//	NSLog(@"%f", elapsedNS);
	
	[tView reloadData];
	
	if (!editing)
		[self scrollToBottom];
	else
		editing = FALSE;
}

- (void)scrollToBottom
{
	//Scroll to bottom to show newest chats
	if([transcript count] > 0)
	{
		NSUInteger index = [transcript count] - 1;
		[tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	}
}

- (IBAction)send:(id)sender
{
	//Send message when send button is tapped
	[self send];
}

- (void)send
{
	//Hide keyboard
	[message resignFirstResponder];
	//If text input is not empty, send message up to server and empty text input. Callback will reload chat
	if (![[message text] isEqualToString:@""])
	{
		NSString *encryptedme = [Security encryptRSA:message.text peer:nil];
		NSString *encryptedyou = [Security encryptRSA:message.text peer:friendId];
		NSString *combined = [encryptedme stringByAppendingFormat:@"|%@", encryptedyou];
		[MGWU sendMessage:combined toFriend:friendId andCallback:@selector(messageSent:) onTarget:self];
	}
}

- (void)messageSent:(NSMutableArray *)t
{
	if (t)
	{
		[message setText:@""];
		[self performSelector:@selector(textViewDidChange:) withObject:message afterDelay:0.1];
		[self reload:t];
	}
}

- (void)keyboardWillShow:(NSNotification *)notif {
	//Animate view to resize along with keyboard displaying
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];

	int delta = 216; //Height of keyboard
	
//	self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-delta);
	tView.frame = CGRectMake(tView.frame.origin.x, tView.frame.origin.y, tView.frame.size.width, tView.frame.size.height-delta);
	footer.frame = CGRectMake(footer.frame.origin.x, footer.frame.origin.y-delta, footer.frame.size.width, footer.frame.size.height);
	
	[UIView commitAnimations];
	
	//Scroll to bottom of table view
	if([transcript count] > 0)
	{
		NSUInteger index = [transcript count] - 1;
		if (tView.contentSize.height-tView.contentOffset.y > tView.frame.size.height+delta)
			[tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
		else
			[tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	}
	
}

- (void)keyboardWillHide:(NSNotification *)notif {
	//Animate view to resize along with keyboard hiding
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
	
	int delta;
	if (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
		delta = 216;
	else
		delta = 162;
	
//	self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height+delta);
	tView.frame = CGRectMake(tView.frame.origin.x, tView.frame.origin.y, tView.frame.size.width, tView.frame.size.height+delta);
	footer.frame = CGRectMake(footer.frame.origin.x, footer.frame.origin.y+delta, footer.frame.size.width, footer.frame.size.height);
	
	[UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	//Only one section for chat
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//One row for each message in the transcript
	return [transcript count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Create cell
	static NSString *CellIdentifier = @"Cell";
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	else
	{
		[cell.message removeFromSuperview];
		cell.message = nil;
	}

	cell.from.text = [[transcript objectAtIndex:indexPath.row] objectForKey:@"from"];
	cell.time.text = [NSString stringWithFormat:@"%@", [[transcript objectAtIndex:indexPath.row] objectForKey:@"time"]];
	
	cell.message = [UIElements chatMessage:[[transcript objectAtIndex:indexPath.row] objectForKey:@"message"]];
	[cell addSubview:cell.message];
	
	if ([[[transcript objectAtIndex:indexPath.row] objectForKey:@"from"] isEqualToString:[user objectForKey:@"username"]])
	{
		cell.message.textAlignment = UITextAlignmentRight;
		if (!cell.right)
			[cell flip];
	}
	else
	{
		cell.message.textAlignment = UITextAlignmentLeft;
		if (cell.right)
			[cell flip];
	}
	
	cell.deleteBlock = ^{
		editing = TRUE;
		[MGWU deleteMessageAtIndex:indexPath.row withFriend:friendId withCallback:@selector(reload:) onTarget:self];
	};
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	//Set variable height of cell based on length of message
	NSString *body = [[transcript objectAtIndex:indexPath.row] objectForKey:@"message"];
	return [UIElements heightForChatCell:body];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
		editing = TRUE;
        //add code here for when you hit delete
		[MGWU deleteMessageAtIndex:indexPath.row withFriend:friendId withCallback:@selector(reload:) onTarget:self];
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
