//
//  DBKAppDelegate.m
//  Divebook
//
//  Created by AndyYou on 2014/8/6.
//  Copyright (c) 2014年 AndyYou. All rights reserved.
//

#import "DBKAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <Crashlytics/Crashlytics.h>
#import "DBKLoginViewController.h"

@implementation DBKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"YOUR_APPLICATION_ID"
                  clientKey:@"YOUR_CLIENT_KEY"];
    [PFFacebookUtils initializeFacebook];
    
    [Crashlytics startWithAPIKey:@"YOUR_KEY"];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

@end
