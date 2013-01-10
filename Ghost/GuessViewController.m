//
//  GuessViewController.m
//  Ghost
//
//  Created by Ashutosh Desai on 12/12/12.
//  Copyright (c) 2012 makegameswithus inc. All rights reserved.
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
	[letter becomeFirstResponder];
	if ([w length] > 0)
		word.text = [[w stringByAppendingString:@" >"] uppercaseString];
	else
		word.text = @">";
	
	if ([w length] < 2)
		[challenge setHidden:YES];
	
	if ([w isEqualToString:@""])
	{
		time.text = @"Select a letter to begin the round";
	}
	else
	{
		timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
		counter = 30;
	}
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)countdown
{
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
	[delegate guessed:nil];
	[timer invalidate];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString *potentialLetter = string;
	
    NSCharacterSet *nonLetters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"] invertedSet];
	
    if ([potentialLetter stringByTrimmingCharactersInSet:nonLetters].length != potentialLetter.length) {
        return NO;
    } else {
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
