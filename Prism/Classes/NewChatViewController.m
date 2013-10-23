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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[username setReturnKeyType:UIReturnKeySend];
	[username setKeyboardAppearance:UIKeyboardAppearanceAlert];
	[username setKeyboardType:UIKeyboardTypeAlphabet];
	[username setDelegate:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:username];
}

- (IBAction)back:(id)sender
{
	[self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)go:(id)sender
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
	
	[self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
