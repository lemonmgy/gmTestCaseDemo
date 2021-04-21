//
//  GMAlert.m
//  gmTestDemo
//
//  Created by lemonmgy on 2018/4/26.
//  Copyright © 2018年 lemonmgy. All rights reserved.
//

#import "GMAlert.h"
#import <objc/runtime.h>

static NSString *alertLabel = @"alertLabel";


@implementation GMAlert

void show_alert(NSString *msg) {
    [GMAlert show:msg andForever:NO];
}

void show_alert_forever(NSString *msg) {
    [GMAlert show:msg andForever:NO];
}

void hidden_alert(NSString *msg) {
    [GMAlert hidden:msg];
}

+ (void)show:(NSString *)title andForever:(BOOL)forever {
    UILabel *label = (UILabel *)objc_getAssociatedObject([UIApplication sharedApplication].keyWindow, (__bridge const void *)(alertLabel));
    if (label) {
        objc_setAssociatedObject([UIApplication sharedApplication].keyWindow, (__bridge const void *)(alertLabel), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [label removeFromSuperview];
    }
    
    label = [UILabel new];
    label.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:15];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 5;
    label.text = title;
    label.alpha = 0.5;
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, (kSCREEN_HEIGHT- 50)/2.0, kSCREEN_WIDTH - 50, 50);
    [label setAdjustsFontSizeToFitWidth:YES];
    label.center = CGPointMake(kSCREEN_WIDTH/2.0, label.center.y);
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    
    if (forever) {
        objc_setAssociatedObject([UIApplication sharedApplication].keyWindow, (__bridge const void *)(alertLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        label.alpha = 1;
    } completion:^(BOOL finished) {
        if (forever) return;
        [UIView animateWithDuration:0.3 delay:0.3 options:0 animations:^{
            label.alpha = 0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
            
        }];
    }];
}

+ (void)hidden:(NSString *)title {
    if (!title.length) {
        title = @"消失中...";
    }
    [[self class] show:title andForever:NO];
}

@end
