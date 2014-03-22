//
//  LPAppDelegate.m
//  LPBicikeLJExample
//
//  Created by Luka Penger on 27/10/13.
//  Copyright (c) 2013 Luka Penger. All rights reserved.
//

#import "LPAppDelegate.h"

@implementation LPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    LPMainViewController *mainViewController = [[LPMainViewController alloc] initWithNibName:@"LPMainViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(0.0/255.0) green:(230.0/255.0) blue:(130.0/255.0) alpha:1.0];

    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
