//
//  AppDelegate.m
//  gmTestDemo
//
//  Created by lemonmgy on 2017/1/22.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "AppDelegate.h"
#import "GMCaseListViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[GMCaseListViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}
@end
