//
//  BrokenLineView.m
//  gmTestDemo
//
//  Created by lemonmgy on 2017/4/5.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "BrokenLineView.h"

@interface BrokenLineView ()
@property (nonatomic, strong) UIScrollView *backScrollView;

@end

@implementation BrokenLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createBrokenLineViewInternalUI];
    }
    return self;
}
//550
- (void)createBrokenLineViewInternalUI {
    self.backScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.backScrollView.backgroundColor = [UIColor redColor];
//    self.backScrollView.showsHorizontalScrollIndicator = NO;
//    self.backScrollView.showsVerticalScrollIndicator = NO;

    
}

- (void)drawRect:(CGRect)rect {
    
}


@end
