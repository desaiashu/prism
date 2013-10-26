//
//  AppDelegate.m
//  Ghost
//
//  Created by Ashutosh Desai on 7/11/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "ChatViewController.h"
#import "Security.h"

@implementation AppDelegate

//Remainder of declaration of externs, see .h file
NSMutableDictionary *user;
BOOL noPush;

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[Security generateKeyPair];
	
	//[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	
	//Set up window/root view controller
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIElements darkColor];
    [self.window makeKeyAndVisible];
	
	//[self.window addSubview:[UIElements statusBar]];
//	[self.window addSubview:[UIElements header:@"desaiashu" withBackButton:YES]];
	//[self.window addSubview:[UIElements enterUsername]];
	//[self.window addSubview:[UIElements centerTextInputField]];
	//[self.window addSubview:[UIElements floatingButtonWithTitle:@"request to chat"]];
	//[self.window addSubview:[UIElements footerButtonWithTitle:@"new chat"]];

//	UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 320, 75)];
//	[cell addSubview:[UIElements friendName:@"desaiashu"]];
//	[cell addSubview:[UIElements friendStatus:@"request sent"]];
//	
//	UIView *cell2 = [[UIView alloc] initWithFrame:CGRectMake(0, 155, 320, 75)];
//	[cell2 addSubview:[UIElements friendName:@"jvrossb"]];
//	[cell2 addSubview:[UIElements friendStatus:@"chat with"]];
//	[cell2 addSubview:[UIElements newChat:4]];
//	
//	[self.window addSubview:cell];
//	[self.window addSubview:cell2];
	
//	UIView *cell3 = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 320, 75)];
//	[cell3 addSubview:[UIElements chatFrom:@"desaiashu"]];
//	[cell3 addSubview:[UIElements chatTime:@"yesterday, 11:57pm"]];
//	[cell3 addSubview:[UIElements chatMessage:@"hey, how's everything going?"]];
//	
//	UIView *cell4 = [[UIView alloc] initWithFrame:CGRectMake(0, 155, 320, 75)];
//	[cell4 addSubview:[UIElements chatFrom:@"desaiashu"]];
//	[cell4 addSubview:[UIElements chatTime:@"yesterday, 11:58pm"]];
//	[cell4 addSubview:[UIElements chatMessage:@"let's try a really long block of text, and see if that changes anything, i'd assume we can get a pretty decent cell height off of this, but again, i'm just trying to find out. what's going to happen? i'm not 100% sure but i hope it works"]];
//	
//	UIView *cell5 = [[UIView alloc] initWithFrame:CGRectMake(0, 290, 320, 75)];
//	UILabel *from = [UIElements chatFrom:@"desaiashu"];
//	CGRect fromFrame = from.frame;
//	from.textAlignment = UITextAlignmentRight;
//	UILabel *time = [UIElements chatTime:@"yesterday, 11:58pm"];
//	CGRect timeFrame = time.frame;
//	time.textAlignment = UITextAlignmentLeft;
//	time.frame = fromFrame;
//	from.frame = timeFrame;
//	UILabel *message = [UIElements chatMessage:@"ok it's starting to look pretty good, we're getting closer to the end"];
//	message.textAlignment = UITextAlignmentRight;
//	[cell5 addSubview:from];
//	[cell5 addSubview:time];
//	[cell5 addSubview:message];
//	
//	[self.window addSubview:cell3];
//	[self.window addSubview:cell4];
//	[self.window addSubview:cell5];
//
//	
//	UIView *footer = [UIElements footer];
//	[footer addSubview:[UIElements footerTextInputField]];
//	[footer addSubview:[UIElements sendButton]];
//	[self.window addSubview:footer];
	
//	[self.window addSubview:[UIElements passcode]];
//	for (int i = 0; i < 12; i++)
//		[self.window addSubview:[UIElements passcodeButtonWithNumber:i]];
	
//	[self.window addSubview:[UIElements about]];
	
	UINavigationController *nc = [[UINavigationController alloc] init];
	self.window.rootViewController = nc;
	nc.navigationBarHidden = TRUE;
	
	//Setup MGWU SDK
	[MGWU loadMGWU:@"pr1v4t33ncrypt3dch4t"];
	
	[MGWU dark];
	
	[MGWU preFacebook];
	
	[MGWU useCrashlyticsWithApiKey:@"90590517f87780a7e95ff36c9a7d9e008c8532a7"];
	
#if TARGET_IPHONE_SIMULATOR
	
	//Simulator
	[MGWU overrideUsername:@"adesai"];
#else
	
	// Device
	[MGWU overrideUsername:@"desaiashu"];
	
#endif
	
	if (![MGWU getUsername])
	{
		//create account
		
	}
	else
	{
		//enter passcode
		GamesViewController *g = [[GamesViewController alloc] init];
		[nc pushViewController:g animated:NO];
	}
	
	//To flag whether push notifications are disabled
	noPush = FALSE;
	
    return YES;
}

//Methods to pass push notifications through to the SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)tokenId {
	[MGWU registerForPush:tokenId];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [MGWU gotPush:userInfo];
	
	//After sending push notification through to the SDK, we want to use it to refresh views if an update has been received
	if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
	{
		//If move has been received
		if ([[userInfo allKeys] containsObject:@"gameid"])
		{
			UINavigationController *nc = (UINavigationController*) self.window.rootViewController;
			UIViewController *vc = nc.topViewController;
			
			//If the current view displayed is the tab bar controller, refresh list of games
			if ([vc isMemberOfClass:[GamesViewController class]])
			{
				[(GamesViewController*)vc refresh];
			}
		}
		//If message has been received
		else if ([[userInfo allKeys] containsObject:@"from"])
		{
			UINavigationController *nc = (UINavigationController*) self.window.rootViewController;
			UIViewController *vc = nc.topViewController;
			
			//If the current view is the tab bar controller, refresh the list of games (so the chat notification icon can be displayed, this could be controlled directly instead of refreshing the whole view)
			if ([vc isMemberOfClass:[GamesViewController class]])
			{
				[(GamesViewController*)vc refresh];
			}
			//Else if the current view is in chat, refresh the chat
			else if ([vc isMemberOfClass:[ChatViewController class]])
			{
				ChatViewController *cvc = (ChatViewController*)vc;
				if ([cvc.friendId isEqualToString:[userInfo objectForKey:@"from"]])
					[cvc refresh];
			}
		}
	}
	else
	{
		//Analytics to track whether users are opening the app in response to recieving a notification
		if ([[userInfo allKeys] containsObject:@"gameid"])
			[MGWU logEvent:@"push_clicked" withParams:@{@"type":@"move"}];
		else if ([[userInfo allKeys] containsObject:@"from"])
			[MGWU logEvent:@"push_clicked" withParams:@{@"type":@"message"}];
	}
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    [MGWU failedPush:error];
	
	//Flag that push notifications were turned off
	noPush = TRUE;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	[MGWU gotLocalPush:notification];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	
//	//When the app is launched from the background, refresh the current view
//	UINavigationController *nc = (UINavigationController*) self.window.rootViewController;
//	UIViewController *vc = nc.topViewController;
//	
//	if ([vc isMemberOfClass:[TabBarController class]])
//		[(TabBarController*)vc refresh];
//	else if ([vc isMemberOfClass:[ChatViewController class]])
//		[(ChatViewController*)vc refresh];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [MGWU handleURL:url];
}

@end
