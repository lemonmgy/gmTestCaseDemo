//
//  GMImageAnimatedTransitioning.h
//  test
//
//  Created by lemonmgy on 2017/1/20.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMPictureBrowserViewController;
typedef enum : NSUInteger {
    InteractiveTransitionStylePrensent,
    InteractiveTransitionStyleDismiss,
    InteractiveTransitionStylePush,
    InteractiveTransitionStylePop,
} InteractiveTransitionStyle;

@interface GMInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL isPan;
@property (nonatomic, assign) InteractiveTransitionStyle transitionStyle;
@property (nonatomic, weak) GMPictureBrowserViewController *pictureViewController;
- (void)addGestureRecognizerWithView:(UIView *)view;

@property (nonatomic, copy) void(^block)(CGPoint translationInView,CGFloat percent, UIGestureRecognizerState state);

@end


@interface GMImageAnimatedTransitioning :NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) UINavigationControllerOperation operation;

@end
