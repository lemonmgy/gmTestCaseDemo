//
//  GMHitCenterVIew.m
//  gmTestDemo
//
//  Created by lemonmgy on 2017/12/29.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "GMHitCenterView.h"

@implementation GMHitCenterView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = self;
    NSLog(@"[%@] 方法:%s 调用",[self class] ,__func__);
    hitView = [super hitTest:point withEvent:event];
    NSLog(@"[%@] 方法:%s 返回值：%@",[self class] ,__func__,hitView);
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL ret = [super pointInside:point withEvent:event];
    NSLog(@"[%@] 方法:%s 返回值：%@",[self class] ,__func__,(ret?@"YES":@"NO"));
    return ret;
}
@end
