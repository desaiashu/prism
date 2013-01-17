//
//  GuessViewController.m
//  Ghost
//
//  Created by Ashutosh Desai on 12/12/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
//

#import "GuessViewController.h"

@interface GuessViewController ()

@end

@implementation GuessViewController

@synthesize delegate, w;

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
	
	//Show the keyboard and take input into the text field
	[letter becomeFirstResponder];
	
	//The word has been set by the GameViewController, if there is no word yet, set it to > (which in the ghosty font is an underline), if there is a word, add a space and > to it
	if ([w length] > 0)
		word.text = [[w stringByAppendingString:@" >"] uppercaseString];
	else
		word.text = @">";
	
	//Only show the challenge button if the length of the word is more than 1, you can't challenge a 1 letter word because you would lose if you did
	if ([w length] < 2)
		[challenge setHidden:YES];
	
	//Set top text to counter or text if it is the first turn
	if ([w isEqualToString:@""])
	{
		time.text = @"Select a letter to begin the round";
	}
	else
	{
		//Set timer to fire every second
		timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
		counter = 30;
	}
}

- (void)countdown
{
	//Every time timer fires, decrement the counter and the time label, if you hit 0 seconds then the player is forced to challenge
	if (counter == 0)
	{
		[delegate guessed:nil];
		[timer invalidate];
	}
	else
	{
		counter--;
		time.text = [NSString stringWithFormat:@"%d", counter];
	}
	
}

- (IBAction)challenge:(id)sender
{
	//If the player challenges, pass back nil
	[delegate guessed:nil];
	[timer invalidate];
}

//This method is called if the user has tapped on a button on the keyboard
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString *potentialLetter = string;
    NSCharacterSet *nonLetters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"] invertedSet];
	
	//If the tapped button is not a letter, don't do anything
    if ([potentialLetter stringByTrimmingCharactersInSet:nonLetters].length != potentialLetter.length) {
        return NO;
    }
	//If it is a letter, send it back to the delegate
	else
	{
		[delegate guessed:potentialLetter];
		[timer invalidate];
        return YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
