//
//  NavigationController.m
//  Ghost
//
//  Created by Ashutosh Desai on 12/14/12.
//  Copyright (c) 2012 makegameswithus inc. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

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
	
	self.navigationBar.backItem.title = @"";
	
	
	[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
	
	[[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor colorWithRed:(63.0/256.0) green:(70.0/256.0) blue:(68.0/256.0) alpha:1.0],
															UITextAttributeFont: [UIFont fontWithName:@"ghosty" size:28.0]}];
	
	[[UINavigationBar appearance] setTitleVerticalPositionAdjustment:7.0 forBarMetrics:UIBarMetricsDefault];
	
	UIImage *barBackBtnImg = [[UIImage imageNamed:@"BackButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
	
	[[UIBarButtonItem appearance] setBackButtonBackgroundImage:barBackBtnImg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearance] setBackButtonBackgroundVerticalPositionAdjustment:4.0 forBarMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -50) forBarMetrics:UIBarMetricsDefault];
	
	[[UIBarButtonItem appearance] setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	
	//[UINavigationBar appearance]
	
	
	//[UIBarButtonItem alloc] initWithImage:<#(UIImage *)#> style:<#(UIBarButtonItemStyle)#> target:<#(id)#> action:<#(SEL)#>
	//UIBarButtonItem *theBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
    //[[UIBarButtonItem appearance] setBackBarButtonItem:theBackButton];
	
//	[[UIBarButtonItem appearance] setTitleTextAttributes:
//	[NSDictionary dictionaryWithObjectsAndKeys:
//	 [UIColor whiteColor], UITextAttributeTextColor,
//	 [UIColor grayColor], UITextAttributeTextShadowColor,
//	 [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
//	 [UIFont fontWithName:@"Cochin-BoldItalic" size:0.0], UITextAttributeFont,
//	 nil]
//												forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
