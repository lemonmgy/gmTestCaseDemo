//
//  GMHelper.m
//  gmTestDemo
//
//  Created by lemonmgy on 2018/4/27.
//  Copyright © 2018年 lemonmgy. All rights reserved.
//

#import "GMHelper.h"

@implementation GMHelper

+ (void)showAnimaton:(UIView *)view completion:(void(^)(void))complet {
    [UIView animateWithDuration:0.1 animations:^{
        view.transform = CGAffineTransformMakeScale(0.001, 1);
    } completion:^(BOOL finished) {
        complet();
        [UIView animateWithDuration:0.1 animations:^{
            view.transform = CGAffineTransformIdentity;
        }];
    }];
}

@end
