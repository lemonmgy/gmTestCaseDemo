//
//  UIViewController+GMExchangeMethod.m
//  gmTestDemo
//
//  Created by lemonmgy on 2018/1/2.
//  Copyright © 2018年 lemonmgy. All rights reserved.
//

#import "UIViewController+GMExchangeMethod.h"
#import <objc/runtime.h>

@implementation UIViewController (GMExchangeMethod)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        exchangeMethod(self, @selector(viewDidLoad), @selector(sw_viewDidLoad));
    });
}

- (void)sw_viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [self sw_viewDidLoad];
}

void exchangeMethod(Class _Nullable cls, SEL m1, SEL m2) {
    Method didLoad = class_getInstanceMethod(cls, m1);
    Method sw_didload = class_getInstanceMethod(cls, m2);
    method_exchangeImplementations(didLoad, sw_didload);
}

@end
