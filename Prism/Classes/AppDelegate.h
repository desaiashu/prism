//
//  AppDelegate.h
//  Ghost
//
//  Created by Ashutosh Desai on 7/11/12.
//  Copyright (c) 2012 makegameswithus inc. Free to use for all purposes.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

//Externs are simply objects that any class can access, these also need to be declared in the .m file
//Externs are used here instead of a singleton class

//Dictionary containing user object retrieved from server
extern NSMutableDictionary *user;
//Bool to flag whether user has push notifications turned on or off
extern BOOL noPush;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;

@end
