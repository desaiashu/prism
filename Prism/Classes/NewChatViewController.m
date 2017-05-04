//
//  NewChatViewController.m
//  Prism
//
//  Created by Ashutosh Desai on 9/4/13.
//  Copyright (c) 2013 makegameswithus inc. All rights reserved.
//

#import "NewChatViewController.h"
#import "Security.h"

@interface NewChatViewController ()

@end

@implementation NewChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
	self = [super init];
    if (self) {
        // Custom initialization
		self.view.backgroundColor = [UIElements backgroundColor];
		
		[self.view addSubview:[UIElements header:@"new chat" withBackButton:YES]];
		[self.view addSubview:[UIElements enterUsername]];
		UIButton *b = [UIElements floatingButtonWithTitle:@"request to chat"];
		[b addTarget:self action:@selector(newchat) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:b];
		UIButton *b2 = [UIElements footerButtonWithTitle:@"invite friends via sms"];
		[b2 addTarget:self action:@selector(inviteFriend) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:b2];
		username = [UIElements centerTextInputField];
		[self.view addSubview:username];
		[username setReturnKeyType:UIReturnKeySend];
		[username setKeyboardAppearance:UIKeyboardAppearanceAlert];
		[username setKeyboardType:UIKeyboardTypeAlphabet];
		[username setDelegate:self];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:username];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (IBAction)back:(id)sender
{
	[self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)go:(id)sender
{
	[self checkUsername];
}

- (void)inviteFriend
{
	if ([MFMessageComposeViewController canSendText])
	{
		MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
		NSString *appstoreurl = @"whisper.desaiashu.com";
		controller.body = [NSString stringWithFormat:@"download whisper (%@) to communicate securely with your friends. start a new chat with my username '%@'",  appstoreurl, [MGWU getUsername]];
		controller.messageComposeDelegate = self;
		controller.wantsFullScreenLayout = NO;
		[self presentModalViewController:controller animated:YES];
		[[UIApplication sharedApplication] setStatusBarHidden:YES];
	}
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)newchat
{
	[self checkUsername];
}

- (void)textFieldChanged:(NSNotification *)notif
{
	NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
	username.text = [username.text stringByTrimmingCharactersInSet:charactersToRemove];
	username.text = [username.text lowercaseString];
}

//Method to send message when done is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self checkUsername];
	return YES;
}

- (void)checkUsername
{
	if ([username.text isEqualToString:@""])
		return;
	else if ([username.text isEqualToString:[MGWU getUsername]])
	{
		[MGWU showMessage:@"You can't chat with yourself" withImage:nil];
		return;
	}
	
	[MGWU getPlayerWithUsername:username.text withCallback:@selector(gotUser:) onTarget:self];
}

- (void)gotUser:(NSDictionary*)u
{
	if (!u)
		return;
	
	NSString *pushMessage = [NSString stringWithFormat:@"%@ has requested to chat", [MGWU getUsername]];
	
	NSString *pubkey = [[NSUserDefaults standardUserDefaults] objectForKey:PUBLIC_TAG];
	
	[MGWU move:@{} withMoveNumber:0 forGame:0 withGameState:@"started" withGameData:@{[MGWU getUsername]:pubkey} againstPlayer:username.text withPushNotificationMessage:pushMessage withCallback:@selector(moveCompleted:) onTarget:self];
}

- (void)moveCompleted:(NSDictionary*)g
{
	if (!g)
		return;
	
	[MGWU showMessage:@"You will be notified when your request to chat has been accepted" withImage:nil];
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
