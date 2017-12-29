//
//  MYIndicatorView.m
//  gmTestDemo
//
//  Created by lemonmgy on 2017/2/7.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYIndicatorView.h"

NSString *animationKey = @"KCBasicAnimation_Rotation";

@interface MYIndicatorView() {
CAShapeLayer *_shapeLayer;
CAShapeLayer *_shapeLayerSub;
}
@property (nonatomic, assign) BOOL show;
@end

@implementation MYIndicatorView

- (void)hiddenIndicator {
    self.show = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

+ (instancetype)showIndicatorWithView:(UIView *)view {
    CGFloat w = 40;
    MYIndicatorView *inview = [[MYIndicatorView alloc]initWithFrame:CGRectMake((view.frame.size.width-w)/2.0, (view.frame.size.height-w)/2.0, w, w)];
    [view addSubview:inview];
    inview.show = YES;
    return inview;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        CGFloat w = self.frame.size.width;
        CGFloat x = 0;
        CGFloat y = 0;
        
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = CGRectMake(x, y, w, w);
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = [UIColor colorWithRed:60/255.0 green:61/255.0 blue:57/255.0 alpha:0.7].CGColor;
//        [UIColor blackColor].CGColor;
        _shapeLayer.lineWidth = 4.0;
        
        _shapeLayerSub = [CAShapeLayer layer];
        _shapeLayerSub.frame = CGRectMake(0, 0, w, w);
        _shapeLayerSub.fillColor = [UIColor clearColor].CGColor;
        _shapeLayerSub.strokeColor = [UIColor whiteColor].CGColor;
        _shapeLayerSub.lineWidth = _shapeLayer.lineWidth;
        _shapeLayerSub.lineCap = @"round";
        
        CGMutablePathRef path =  CGPathCreateMutable();
        CGPathAddArc(path, &CGAffineTransformIdentity, w/2.0,w/2.0, w/2.0, 0,M_PI*2, 0);
        _shapeLayer.path = path;
        CGPathRelease(path);
        
        path = CGPathCreateMutable();
        CGPathAddArc(path, &CGAffineTransformIdentity, w/2.0, w/2.0, w/2.0, 0,M_PI*2*0.25, 0);
        _shapeLayerSub.path = path;
        CGPathRelease(path);
        
        [self.layer addSublayer:_shapeLayer];
        [_shapeLayer addSublayer:_shapeLayerSub];
    }
    return self;
}

- (void)setShow:(BOOL)show {
    _show = show;
    if (!_show) {
        if ([_shapeLayerSub animationForKey:animationKey]) [_shapeLayerSub removeAnimationForKey:animationKey];
    }else {
        CABasicAnimation *basicAnimation = (CABasicAnimation *)[_shapeLayerSub animationForKey:animationKey];
        if (basicAnimation) return;
        basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        basicAnimation.toValue = [NSNumber numberWithFloat:M_PI*2];
        basicAnimation.duration = 0.5;
        basicAnimation.repeatCount = HUGE_VALF;
        [_shapeLayerSub addAnimation:basicAnimation forKey:animationKey];
    }
}

- (void)dealloc {
    if ([_shapeLayerSub animationForKey:animationKey]) [_shapeLayerSub removeAnimationForKey:animationKey];
}

@end
