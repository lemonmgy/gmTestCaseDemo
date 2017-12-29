//
//  GMImageAnimatedTransitioning.m
//  test
//
//  Created by lemonmgy on 2017/1/20.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "GMImageAnimatedTransitioning.h"
#import "GMPictureBrowserViewController.h"
#import "GMPictureSwitchView.h"
@interface GMImageAnimatedTransitioning ()

@end

@implementation GMImageAnimatedTransitioning


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
//    return 1.1;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.operation == UINavigationControllerOperationPush) {
        [self presentAnimateTransition:transitionContext];
    } else if (self.operation == UINavigationControllerOperationPop){
        [self dismissAnimateTransition:transitionContext];
    }
    
}

- (void)presentAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    GMPictureBrowserViewController *toVc = (GMPictureBrowserViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVc];
    
    toVc.view.frame = finalFrame;
    UIView *container = [transitionContext containerView];
    [container addSubview:toVc.view];
    
    toVc.mirrorTopView.hidden = YES;
    toVc.mirrorBottomView.hidden = NO;
    toVc.switchView.hidden = YES;
    toVc.hiddenOutIcon = YES;
    
    [toVc mirrorTransformWithEntering:YES andAllow:YES];
    [toVc curtainSetFrame:NO transform:NO hidden:YES];
    
    toVc.backViewAlpha = 0;
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        [toVc mirrorTransformWithIdentity];
        toVc.backViewAlpha = 1;
    }completion:^(BOOL finished) {
        toVc.mirrorTopView.hidden = YES;
        toVc.mirrorBottomView.hidden = YES;
        toVc.switchView.hidden = NO;
        [transitionContext completeTransition:YES];
    }];
}

- (void)dismissAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    GMPictureBrowserViewController *fromVc = (GMPictureBrowserViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *container = [transitionContext containerView];
    [container addSubview:toVc.view];
    [container bringSubviewToFront:fromVc.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [fromVc mirrorViewLayout];
    fromVc.hiddenOutIcon = YES;

    if (!fromVc.isPan) {
        fromVc.mirrorTopView.hidden = NO;
        fromVc.mirrorBottomView.hidden = NO;
        fromVc.switchView.hidden = YES;
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut  animations:^{
            if (![fromVc mirrorTransformWithEntering:NO andAllow:YES]) {
                fromVc.mirrorBottomView.alpha = 0;
                fromVc.mirrorTopView.alpha = 0;
            }
            fromVc.backViewAlpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            fromVc.hiddenOutIcon = NO;
        }];
    }else {
        fromVc.mirrorTopView.hidden = YES;
        fromVc.mirrorBottomView.hidden = NO;
        fromVc.switchView.hidden = YES;
        if ([fromVc mirrorTransformWithEntering:NO andAllow:NO]) {
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut  animations:^{
                fromVc.backViewAlpha = 0;
            } completion:^(BOOL finished) {//手势完成
                if ([transitionContext transitionWasCancelled]) {//取消了
                    [UIView animateWithDuration:duration animations:^{
                        fromVc.mirrorBottomView.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {
                        [transitionContext completeTransition:NO];
                        fromVc.backViewAlpha = 1;
                        fromVc.mirrorBottomView.hidden = YES;
                        fromVc.switchView.hidden = NO;
                    }];
                }else{//成功了
                    fromVc.mirrorTopView.frame = fromVc.mirrorBottomView.frame;
                    fromVc.mirrorBottomView.hidden = YES;
                    fromVc.mirrorTopView.hidden = NO;
                    [UIView animateWithDuration:duration animations:^{
                        CGRect rect = fromVc.clickViewFrame;
                        rect.origin.y = rect.origin.y;
                        fromVc.mirrorTopView.frame = rect;
                    }completion:^(BOOL finished) {
                        [transitionContext completeTransition:YES];
                        fromVc.hiddenOutIcon = NO;
                    }];
                }
            }];
        }else {//不在屏幕内
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut  animations:^{
                fromVc.backViewAlpha = 0;
                fromVc.mirrorBottomView.alpha = 0;
            } completion:^(BOOL finished) {//手势完成
                if ([transitionContext transitionWasCancelled]) {//取消了
                    [UIView animateWithDuration:duration animations:^{
                        fromVc.mirrorBottomView.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {
                        [transitionContext completeTransition:NO];
                        fromVc.mirrorBottomView.hidden = YES;
                        fromVc.switchView.hidden = NO;
                    }];
                }else{//成功了
                        [transitionContext completeTransition:YES];
                        fromVc.hiddenOutIcon = NO;
                }
            }];
        }
        
    }
}


@end
