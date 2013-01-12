//
//  PopupViewController.m
//  Ghost
//
//  Created by Ashutosh Desai on 1/9/13.
//  Copyright (c) 2013 makegameswithus inc. All rights reserved.
//

#import "PopupViewController.h"

@interface PopupViewController ()

@end

@implementation PopupViewController

@synthesize titleString, messageString, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)dismiss:(id)sender
{
	[delegate dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	//Set labels to match strings, the strings are set by the GameViewController
	titleLabel.text = titleString;
	messageLabel.text = messageString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
