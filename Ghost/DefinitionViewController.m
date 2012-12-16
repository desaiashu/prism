//
//  DefinitionViewController.m
//  Ghost
//
//  Created by Ashutosh Desai on 12/14/12.
//  Copyright (c) 2012 makegameswithus inc. All rights reserved.
//

#import "DefinitionViewController.h"

@interface DefinitionViewController ()

@end

@implementation DefinitionViewController

@synthesize textView, definition;

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
	textView.text = definition;
	textView.font = [UIFont fontWithName:@"Nexa Bold" size:18.0];
	
	UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
																						  action:@selector(getDismissed)];
	swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
	swipeRecognizer.delegate = self;
	
	[self.view addGestureRecognizer:swipeRecognizer];
}

-(void)getDismissed
{
	[self.presentingViewController dismissModalViewControllerAnimated:YES];
	// call dismissViewControllerAnimated:completion: by the presenting view controller
	// you can use delegation or direct call using presentingViewController property
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // touching objects of type UIControl will not dismiss the view controller
    return ![touch.view isKindOfClass:[UITextView class]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
