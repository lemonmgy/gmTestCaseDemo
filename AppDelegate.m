//
//  AppDelegate.m
//  gmTestDemo
//
//  Created by lemonmgy on 2017/1/22.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "AppDelegate.h"
#import "MYTestEntranceViewController.h"
#import "MYNavigationController.h"
#import "UMMobClick/MobClick.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    MYTestEntranceViewController *vc = [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil] instantiateViewControllerWithIdentifier:@"MYTestEntranceViewController2222"];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self newLanchImage];
    
    [self.window makeKeyAndVisible];
    
    
    
    UMConfigInstance.appKey = @"596daf2cbbea8369490005f9";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    return YES;
}

- (UIImage*)newLanchImage {
    UIImage *sourceImage = [self lanchImage];
    CGImageRef sourceImageRef = [sourceImage CGImage];
    CGRect rectImage = CGRectMake(0,
                                  (sourceImage.size.height - (100)) * sourceImage.scale,
                                  sourceImage.size.width * sourceImage.scale,
                                  (100.f) * sourceImage.scale);
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rectImage);
    return [UIImage imageWithCGImage:newImageRef];
}

- (UIImage *)lanchImage{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";
    NSString *launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict){
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]){
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return [UIImage imageNamed:launchImage];
}

- (void)test{
    
    
    //    NSMutableArray *monthArr = [NSMutableArray array];
    
    
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *date = [NSDate date];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSTimeInterval time = [timeZone secondsFromGMTForDate:date];
    NSDate *currentDate = [date dateByAddingTimeInterval:time];
    
    NSDateComponents *currentDateComponents = [calendar components: NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday fromDate:currentDate];
    
    NSDateComponents *tempDateComponents = [currentDateComponents copy];
    tempDateComponents.day = 1;
    NSDate *firstDay = [calendar dateFromComponents:tempDateComponents];
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstDay];
    
    
    
    NSMutableArray *dayArray = [NSMutableArray array];
    for (int i = 1 ; i < range.length+1; i++)
    {
        tempDateComponents.day = i;
        NSDate *tempDate = [calendar dateFromComponents:tempDateComponents];
        NSDateComponents *tempComponents = [calendar components: NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday fromDate:tempDate];
        [dayArray addObject:tempComponents];
        //            NSDate *tomorrowDate = [NSDate dateWithTimeInterval:i*24*60*60 sinceDate:tempDate];
        //        NSLog(@"%ld = %ld",(long)tempComponents.day,tempComponents.weekday);
    }
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSString *currentDateStr = [formatter stringFromDate:currentDate];
    
    //    NSDate *strCurrentDate = [formatter dateFromString:@"2016-11-03 22:59:13"];
    
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
