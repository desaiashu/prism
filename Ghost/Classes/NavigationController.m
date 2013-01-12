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
	
	//Here we customize the nav bar using the Appearance APIs
	//Set the background image of the navigation bar to be our custom nav bar
	[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
	
	//Set the title of the nav bar to have our custom font + color
	[[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor colorWithRed:(63.0/256.0) green:(70.0/256.0)
																									 blue:(68.0/256.0) alpha:1.0],
															UITextAttributeFont: [UIFont fontWithName:@"ghosty" size:28.0]}];
	
	//Adjust the position of the title to account for the fact that our custom nav bar is taller than the default one
	[[UINavigationBar appearance] setTitleVerticalPositionAdjustment:7.0 forBarMetrics:UIBarMetricsDefault];
	
	//Set the back button to have the back image, use the cap insets to prevent any stretching out of the image due to the text in the back button
	UIImage *barBackBtnImg = [[UIImage imageNamed:@"BackButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
	[[UIBarButtonItem appearance] setBackButtonBackgroundImage:barBackBtnImg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	
	//Adjust the position of the back button
	[[UIBarButtonItem appearance] setBackButtonBackgroundVerticalPositionAdjustment:4.0 forBarMetrics:UIBarMetricsDefault];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
