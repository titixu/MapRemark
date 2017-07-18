//
//  AppDelegate.m
//  MapRemark
//
//  Created by SamXu on 17/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

#import "AppDelegate.h"
@import Firebase;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];
    return YES;
}


@end
