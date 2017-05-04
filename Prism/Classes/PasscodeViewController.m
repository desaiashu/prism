//
//  PasscodeViewController.m
//  Prism
//
//  Created by Ashutosh Desai on 10/23/13.
//  Copyright (c) 2013 makegameswithus inc. All rights reserved.
//

#import "PasscodeViewController.h"
#import "UIElements.h"

@interface PasscodeViewController ()

@end

@implementation PasscodeViewController

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
		self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		self.view.backgroundColor = [UIElements backgroundColor];
		[self.view addSubview:[UIElements header:@"enter passcode" withBackButton:NO]];
		passcode = [UIElements passcode];
		passcode.text = @"";
		[self.view addSubview:passcode];
		for (int i = 0; i < 12; i++)
		{
			UIButton *b = [UIElements passcodeButtonWithNumber:i];
			[b addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
			[self.view addSubview:b];
		}
    }
    return self;
}

- (id)initAndCreate
{
	self = [self init];
	return self;
}

- (id)initAndConfirm
{
	self = [self init];
	return self;
}

- (void)buttonTapped:(id)sender
{
	if ([(UIButton*)sender tag] == 10)
		return;
		
	if ([(UIButton*)sender tag] == 11)
	{
		if ([passcode.text length] > 5)
			passcode.text = [passcode.text substringToIndex:[passcode.text length]-6];
		else
			passcode.text = @"";
			
		return;
	}
		
	if ([passcode.text length] == 0)
		passcode.text = [NSString stringWithFormat:@"%i", [(UIButton*)sender tag]];
	else if ([passcode.text length] < 15)
		passcode.text = [passcode.text stringByAppendingFormat:@"     %i", [(UIButton*)sender tag]];
	
	if ([passcode.text length] > 15)
	{
		if ([passcode.text isEqualToString:@"5     5     5     5"])
			[self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5];
		else
			[self performSelector:@selector(delete) withObject:nil afterDelay:0.5];
	}
}

- (void)dismiss
{
	[self.presentingViewController dismissModalViewControllerAnimated:YES];
}
	
- (void)delete
{
	passcode.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
