//
//  AppDelegate.m
//  PhotoApp
//
//  Created by Jo Tu on 7/30/16.
//  Copyright © 2016 Turn To Tech. All rights reserved.
//

#import "AppDelegate.h"
#import <Firebase/Firebase.h>
#import <AFNetworking/AFNetworking.h>
#import "ASFSharedViewTransition.h"
#import "FirstViewController.h"
#import "PostDetailController.h"
#import <UIKit/UIKit.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];
    self.dao = [DAO sharedManager];
    
    NSString *hasLaunchedKey = @"HasLaunched";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; //fetches metadata and pushes them into real time database once during app lifecycle
    bool hasLaunched = [defaults boolForKey:hasLaunchedKey];
    
    if (!hasLaunched) {
        [self.dao fetchMetaDataFromStorage];
        [defaults setBool:true forKey:hasLaunchedKey];
    }
//    
//    [ASFSharedViewTransition addTransitionWithFromViewControllerClass:[FirstViewController class]
//                                                ToViewControllerClass:[PostDetailController class]
//                                             WithNavigationController:(UINavigationController *)self.window.rootViewController
//                                                         WithDuration:0.3f];
    
        [NSTimer scheduledTimerWithTimeInterval:1.2                                   target:self
                                       selector:@selector(fetchInfoAfterOneSecLoad)
                                       userInfo:nil
                                        repeats:NO];
    
    return YES;
}


-(void)fetchInfoAfterOneSecLoad{
    [self.dao getImageDownloadURLForCollectionView];

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
