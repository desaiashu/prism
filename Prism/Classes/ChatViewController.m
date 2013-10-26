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

- (id)initWithFriend:(NSString*)friend
{
    self = [super init];
    if (self) {
        // Custom initialization
		//Initialize the array to empty
		transcript = [[NSMutableArray alloc] init];
		friendId = friend;
		[self.view addSubview:[UIElements header:friendId withBackButton:YES]];
		tView = [UIElements tableView];
		tView.delegate = self;
		tView.dataSource = self;
		[self.view addSubview:tView];
		UIView *footer = [UIElements footer];
		message = [UIElements footerTextInputField];
		UIButton *sendButton = [UIElements sendButton];
		[sendButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
		[footer addSubview:message];
		[footer addSubview:sendButton];
		[self.view addSubview:footer];
		
		//Set variables for text entry field
		[message setReturnKeyType:UIReturnKeySend];
		[message setKeyboardAppearance:UIKeyboardAppearanceAlert];
		[message setDelegate:self];
		
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
	for (int i = 0; i < [transcript count]; i++)
	{
		NSString *body = [[transcript objectAtIndex:i] objectForKey:@"message"];
		NSArray *messageParts = [body componentsSeparatedByString:@"|"];
	
		if ([[[transcript objectAtIndex:i] objectForKey:@"from"] isEqualToString:[user objectForKey:@"username"]])
			body = [Security decryptRSA:[messageParts objectAtIndex:0]];
		else
			body = [Security decryptRSA:[messageParts objectAtIndex:1]];
		
		if (!body || [body isEqualToString:@""])
			body = @"this message could not be decrypted";
		
		[[transcript objectAtIndex:i] setObject:body forKey:@"message"];
	}
	
	[tView reloadData];
	
	[self scrollToBottom];
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
		[self reload:t];
	}
}

//Method to send message when done is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self send];
	return YES;
}

- (void)keyboardWillShow:(NSNotification *)notif {
	//Animate view to resize along with keyboard displaying
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];

	int delta = 216; //Height of keyboard
	
	self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-delta);
	
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
	
	self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height+delta);
	
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
		if (!cell.right)
			[cell flip];
	}
	else
	{
		if (cell.right)
			[cell flip];
	}
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	//Set variable height of cell based on length of message
	NSString *body = [[transcript objectAtIndex:indexPath.row] objectForKey:@"message"];
	return [UIElements heightForChatCell:body];
}

//When tableViewCell is tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	ChatTableViewCell *c = (ChatTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	//Remove highlight on selected cell
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	//[MGWU deleteMessageAtIndex:indexPath.row withFriend:friendId withCallback:@selector(reload:) onTarget:self];
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
