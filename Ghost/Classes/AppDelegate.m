//
//  AppDelegate.m
//  Ghost
//
//  Created by Ashutosh Desai on 7/11/12.
//  Copyright (c) 2012 makegameswithus inc. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "GameViewController.h"
#import "ChatViewController.h"

@implementation AppDelegate

//Remainder of declaration of externs, see .h file
NSMutableDictionary *user;
BOOL noPush;

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	//Setup MGWU SDK
	[MGWU loadMGWU:@"spooky"];
	
	[MGWU dark];
	
	[MGWU forceFacebook];
	
	[MGWU setReminderMessage:@"Come back and play Ghost!"];
	
	[MGWU setAppiraterAppId:@"588194639" andAppName:@"Ghost"];
	
	[MGWU setTapjoyAppId:@"a473fe74-998d-40b8-b051-4e5566138eb9" andSecretKey:@"e8f0ahK6TFZp20FCfvwh"];
	
	[MGWU useCrashlyticsWithApiKey:@"90590517f87780a7e95ff36c9a7d9e008c8532a7"];
	
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
			if ([vc isMemberOfClass:[TabBarController class]])
			{
				[(TabBarController*)vc refresh];
			}
			//Else if current view is in game, refresh the game
			else if ([vc isMemberOfClass:[GameViewController class]])
			{
				GameViewController *gvc = (GameViewController*)vc;
				if ([[gvc.game objectForKey:@"gameid"] isEqualToNumber:[userInfo objectForKey:@"gameid"]])
					[gvc refresh];
			}
		}
		//If message has been received
		else if ([[userInfo allKeys] containsObject:@"from"])
		{
			UINavigationController *nc = (UINavigationController*) self.window.rootViewController;
			UIViewController *vc = nc.topViewController;
			
			//If the current view is the tab bar controller, refresh the list of games (so the chat notification icon can be displayed, this could be controlled directly instead of refreshing the whole view)
			if ([vc isMemberOfClass:[TabBarController class]])
			{
				[(TabBarController*)vc refresh];
			}
			//Else if the current view is in game, refresh the game (so the badge in the corner can be updated, this could be incremented directly instead of refreshing the whole view)
			else if ([vc isMemberOfClass:[GameViewController class]])
			{
				GameViewController *gvc = (GameViewController*)vc;
				if ([gvc.opponentName isEqualToString:[userInfo objectForKey:@"from"]])
					[gvc refresh];
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
	
	//If the user exits the app while he is currently guessing a letter, tell the game that he quit. This is in order to prevent people from cheating by leaving the app and pausing the 30 second timer
	UINavigationController *nc = (UINavigationController*) self.window.rootViewController;
	UIViewController *vc = nc.topViewController;
	
	if ([vc isMemberOfClass:[GameViewController class]])
	{
		if ([(GameViewController*)vc inGuess])
			[(GameViewController*)vc quit];
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	
	//When the app is launched from the background, refresh the current view
	UINavigationController *nc = (UINavigationController*) self.window.rootViewController;
	UIViewController *vc = nc.topViewController;
	
	if ([vc isMemberOfClass:[TabBarController class]])
		[(TabBarController*)vc refresh];
	else if ([vc isMemberOfClass:[GameViewController class]])
		[(GameViewController*)vc refresh];
	else if ([vc isMemberOfClass:[ChatViewController class]])
		[(ChatViewController*)vc refresh];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//- (void)applicationWillTerminate:(UIApplication *)application
//{
//	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [MGWU handleURL:url];
}
//
//- (void)applicationWillTerminate:(UIApplication *)application {
//    // FBSample logic
//    // if the app is going away, we close the session object
//	[MGWU closefb];
//}

@end
