//
//  UINavigationController+MYPushViewController.m
//  test
//
//  Created by lemonmgy on 2017/1/6.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "UIViewController+MYPush.h"

@implementation UIViewController (MYPush)
- (void)pushViewController:(NSString *)viewController {

    if (self.navigationController) {
        [self.navigationController pushViewController:[NSClassFromString(viewController) new] animated:YES];
    }
}

@end
