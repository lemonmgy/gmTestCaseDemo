//
//  MYEntranceViewController.m
//  test
//
//  Created by lemonmgy on 2017/1/19.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYEntranceViewController.h"

@interface MYEntranceViewController ()

@end

@implementation MYEntranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor brownColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"测试页面";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看" style:UIBarButtonItemStyleDone target:self action:@selector(gotoTabBarController)];
    
}

- (void)gotoTabBarController {
    
    UITabBarController *barC = [[UITabBarController alloc]init];
    
    for (int row = 1; row <= 4; row++) {
        MainViewController *mainVc = [[MainViewController alloc]init];
        MYNavigationController *navVc = [[MYNavigationController alloc] initWithRootViewController:mainVc];

        [self datas:row block:^(NSArray *array, NSString *name) {
            mainVc.dataArr = array;
            navVc.title = name;
        }];
        
        if (row==4) navVc.startAnimation = YES;
        mainVc.navigationItem.title = navVc.title;
        barC.tabBarItem.image = [UIImage imageNamed:@"checkbox_pic"];
        [barC addChildViewController:navVc];
    }
     [barC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:barC animated:YES completion:nil];
}

- (void)datas:(int)row block:(void(^)(NSArray*array, NSString *name))block {
    
    NSArray *arr = @[];
    NSString *nam = @"";
    switch (row) {
        case 1:
        {
            arr = kOneArray;
           nam = @"SystemControls";
        }
            break;
        case 2:
        {
            arr = kTwoArray;
            nam = @"CustomControls";
        }
            break;
        case 3:
        { //   navanimation
            arr = kThreeArray;
            nam = @"UIEffect";
        }
            break;
        case 4:
        { //   navanimationb
            arr = kFourArray;
            nam = @"navanimation";
        }
            break;
    }
    
    if (block) block(arr,nam);
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGSize size = CGSizeMake(1.0f, 1.0f);
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



@end

