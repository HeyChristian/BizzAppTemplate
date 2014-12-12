//
//  AppDelegate.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 6/29/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "MenuNavigationController.h"
#import "MenuViewController.h"
#import "HomeViewController.h"
#import "Tools.h"
#import "Curl.h"


@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
 
    
    
    
    [Parse setApplicationId:@"nTQTX4JCxB3VDm7vtvTQLGdCMKKKYfjAVeUBmreA"
                  clientKey:@"xa82QfjvKm4E9bKO3HQG5XtWjWSSA9qslsMEHUwU"];
    
    
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [Tools setCurrentUserImageData];
    
    
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                             message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            [alert show];
        }
    }
    
    /*
    #define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    if(IS_OS_8_OR_LATER) {
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
        [locationManager startUpdatingLocation];
    }*/
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Create content and menu controllers
    //
    
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"iPhoneStoryboard" bundle:nil];
    HomeViewController *homeViewController = [mystoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    
    MenuNavigationController *navigationController = [[MenuNavigationController alloc] initWithRootViewController:homeViewController];
    
    
    MenuViewController *menuController = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];
    
    // Create frosted view controller
    //
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.delegate = self;
    
    // Make it a root controller
    //
    self.window.rootViewController = frostedViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    [Curl SendCurlPost];
    
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
