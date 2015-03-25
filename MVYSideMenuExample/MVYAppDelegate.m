//
//  MVYAppDelegate.m
//  MVYSideMenuExample
//
//  Created by Álvaro Murillo del Puerto on 10/07/13.
//  Copyright (c) 2013 Mobivery. All rights reserved.
//

#import "MVYAppDelegate.h"

#import "MVYSideMenuController.h"
#import "MVYMenuViewController.h"
#import "MVYContentViewController.h"

@implementation MVYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	
	MVYMenuViewController *menuVC = [[MVYMenuViewController alloc] initWithNibName:@"MVYMenuViewController" bundle:nil];
	MVYContentViewController *contentVC = [[MVYContentViewController alloc] initWithNibName:@"MVYContentViewController" bundle:nil];
	UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:contentVC];
	MVYSideMenuOptions *options = [[MVYSideMenuOptions alloc] init];
	options.contentViewScale = 1.0;
	options.contentViewOpacity = 0.05;
	options.shadowOpacity = 0.0;
    //options.blurRadius = 5.f;
    //options.blurRadius = O.f;

	MVYSideMenuController *sideMenuController = [[MVYSideMenuController alloc] initWithMenuViewController:menuVC
																					contentViewController:contentNavigationController
																								  options:options];
	sideMenuController.menuFrame = CGRectMake(0, 0, 220.0, self.window.bounds.size.height );
	
	self.window.rootViewController = sideMenuController;
    [self.window makeKeyAndVisible];
    return YES;
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
