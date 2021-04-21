//
//  MYButton.m
//  test
//
//  Created by lemonmgy on 2016/11/28.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import "MYButton.h"

@implementation MYButton

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    [self.superview touchesBegan:[NSSet setWithObject:touch] withEvent:event];
    NSLog(@"%s",__func__);
    return YES;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    [self.superview touchesMoved:[NSSet setWithObject:touch] withEvent:event];

    NSLog(@"%s",__func__);

    return YES;
}

@end
