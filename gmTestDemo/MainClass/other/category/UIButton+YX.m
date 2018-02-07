//
//  UIButton+YX.m
//  MoneyEye
//
//  Created by lemonmgy on 2017/2/13.
//  Copyright © 2017年 yinxun. All rights reserved.
//

#import "UIButton+YX.h"
#import <objc/runtime.h>

@implementation UIButton (YX)


- (void)expandClickAreaWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right {
    objc_setAssociatedObject(self, @"expandClick", @(YES), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @"expandInsettop", @(top), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @"expandInsetleft", @(left), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @"expandInsetbottom", @(bottom), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @"expandInsetright", @(right), OBJC_ASSOCIATION_ASSIGN);
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%@",self);
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    NSLog(@"%@",self);
     BOOL expandClick = [objc_getAssociatedObject(self, @"expandClick") boolValue];
    
    if (expandClick) {
        CGFloat top = [objc_getAssociatedObject(self, @"expandInsettop") floatValue];
        CGFloat left = [objc_getAssociatedObject(self, @"expandInsetleft") floatValue];
        CGFloat bottom = [objc_getAssociatedObject(self, @"expandInsetbottom") floatValue];
        CGFloat right = [objc_getAssociatedObject(self, @"expandInsetright") floatValue];
        CGRect frame = CGRectMake(0, 0, self.bounds.size.width + right+left, self.bounds.size.height + bottom+top);
        if (CGRectContainsPoint(frame, CGPointMake(point.x+left, point.y+bottom))){
        return YES;
        }
    }
    
    return [super pointInside:point withEvent:event];
}

@end
