//
//  AppDelegate.m
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "AppDelegate.h"
#import "BCTNavigationVC.h"
#import "BCTMainVC.h"
#import "BCTMacros.h"
#import "BCTVCManager.h"
#import "BCTIOManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:kBCTScreenBounds];
    
    BCTMainVC* mainVC = [[BCTMainVC alloc] init];
        
    BCTNavigationVC* navVC = [[BCTNavigationVC alloc] initWithRootViewController:mainVC];
    
    self.window.rootViewController = navVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [BCTVCManager sharedManager].navigationVC = navVC;
    
    [BCTVCManager sharedManager].mainVC = mainVC;
    
    [self.window makeKeyAndVisible];
    
    [BCTIOManager sharedManager].phoneNumber = @"18563816406";
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
