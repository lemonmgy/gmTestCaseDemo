//
//  MYTransionPush.m
//  test
//
//  Created by lemonmgy on 2017/1/5.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYAnimatedTransitioning.h"
#import "MYAnimatedEndViewController.h"



@implementation MYAnimatedTransitioning


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    if (self.operation == UINavigationControllerOperationPush) {
//        [self pushAnimateTransition:transitionContext];
        [self presentAnimateTransition:transitionContext];
    } else if (self.operation == UINavigationControllerOperationPop){
//        [self popAnimateTransition:transitionContext];
        [self dismissAnimateTransition:transitionContext];
    }
    
}


- (void)presentAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
     
    MYAnimatedEndViewController *toVc = (MYAnimatedEndViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVc];
    
    toVc.view.frame = finalFrame;
    toVc.bcakView.alpha = 0;
    toVc.imageView.frame = CGRectMake(toVc.startFrame.origin.x, toVc.startFrame.origin.y + 64, toVc.startFrame.size.width, toVc.startFrame.size.height);
    
    UIView *container = [transitionContext containerView];
    [container addSubview:toVc.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:0.1 animations:^{
        toVc.bcakView.alpha = 1;
    } completion:^(BOOL finished) {
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        toVc.imageView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, toVc.startFrame.size.height/toVc.startFrame.size.width * kSCREEN_WIDTH);
        toVc.imageView.center = toVc.view.center;
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];

    }];
    }];

}

- (void)dismissAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    MYAnimatedEndViewController *fromVc = (MYAnimatedEndViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
 
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *container = [transitionContext containerView];
   
    [container addSubview:toVc.view];
    [container bringSubviewToFront:fromVc.view];
    
    fromVc.view.backgroundColor = [UIColor clearColor];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration/2.0 animations:^{
            fromVc.bcakView.alpha = 0;


        }];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (fromVc.show) {
        fromVc.imageView.alpha = 0;    
        }
        
        fromVc.imageView.frame = CGRectMake(fromVc.startFrame.origin.x, fromVc.startFrame.origin.y + 64, fromVc.startFrame.size.width, fromVc.startFrame.size.height);

    } completion:^(BOOL finished) {
        
            [transitionContext completeTransition:YES];
        
    }];

          

    
//    [UIView animateWithDuration:duration animations:^{
//        fromVc.view.transform = CGAffineTransformMakeTranslation(kSCREEN_WIDTH, 0);
//    } completion:^(BOOL finished) {
//        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//    }];
}

- (void)pushAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    //    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    NSLog(@"container ===== %@     ....  %@",toView,fromView);

    
//    CGRect rect = [UIScreen mainScreen].bounds;
     CGRect finalFrame = [transitionContext finalFrameForViewController:toVc];
//     CGRect initialFrame = [transitionContext initialFrameForViewController:toVc];
     toVc.view.frame = finalFrame;
    toVc.view.transform = CGAffineTransformMakeTranslation(kSCREEN_WIDTH, 0);
    
    UIView *container = [transitionContext containerView];
    
    [container addSubview:toVc.view];
    
    NSLog(@"%@",container.subviews);
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration animations:^{
        //        toVc.view.frame = finalFrame;
        toVc.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
    }];
}


- (void)popAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
//    CGRect rect = [UIScreen mainScreen].bounds;
//    [self log:rect name:@"rect"];
//    CGRect finalFrame = [transitionContext finalFrameForViewController:fromVc];
//    [self log:finalFrame name:@"finalFrame"];
//    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVc];
//    [self log:initialFrame name:@"initialFrame"];
    //        fromVc.view.frame = initialFrame;
    
    UIView *container = [transitionContext containerView];
    NSLog(@"popcontainer ===== %@",container.subviews);

    [container addSubview:toVc.view];
    [container bringSubviewToFront:fromVc.view];
    NSLog(@"pop = %@",container.subviews);
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration animations:^{
        //        toVc.view.frame = finalFrame;
        fromVc.view.transform = CGAffineTransformMakeTranslation(kSCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        NSLog(@"%d",[transitionContext transitionWasCancelled]);
    }];
}

 
@end
