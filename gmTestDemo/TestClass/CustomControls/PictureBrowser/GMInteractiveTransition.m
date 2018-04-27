//
//  GMInteractiveTransition.m
//  test
//
//  Created by lemonmgy on 2017/1/20.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "GMInteractiveTransition.h"
#import "GMPictureBrowserViewController.h"
@interface GMInteractiveTransition()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *panView;
@property (nonatomic, weak) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) BOOL allowPan;

@end

@implementation GMInteractiveTransition
 
- (void)addGestureRecognizerWithView:(UIView *)view {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        pan.delegate = self;
        [view addGestureRecognizer:pan];
    self.pan = pan;
    self.panView = view;
    [view addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    UIScrollView *imageScrollView = (UIScrollView *)object;
    if (self.pan.enabled == NO &&
        imageScrollView.contentOffset.y <= 5 &&
        imageScrollView.zoomScale == imageScrollView.minimumZoomScale) {
        self.pan.enabled = YES;
        NSLog(@"self.pan.enabled = YES;");
    }else if (self.pan.enabled == YES &&
              imageScrollView.contentOffset.y > 5) {
        self.pan.enabled = NO;
        NSLog(@"self.pan.enabled = NO;");
    }
}

-(void)dealloc {
    [self.panView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)handleGesture:(UIPanGestureRecognizer *)pan {
    if (![pan.view isKindOfClass:[UIScrollView class]]) {
        return;
    }

    NSLog(@"触发手势");
    UIScrollView *imageScrollView = (UIScrollView*)pan.view;
    
    
    CGPoint point = [pan translationInView:pan.view];
    CGFloat percent = point.y/self.pictureViewController.view.frame.size.height;
    NSLog(@"%f",imageScrollView.contentOffset.y);
    
    log_point(point, @"point");

    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.isPan = YES;
            [self point:point percent:percent state:UIGestureRecognizerStateBegan];
            [self startGesture];
            break;
        case UIGestureRecognizerStateChanged:{
           percent = [self point:point percent:percent state:UIGestureRecognizerStateChanged];
            [self updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            [self completePoint:point percent:percent state:UIGestureRecognizerStateEnded];
            break;
        }
        case UIGestureRecognizerStateCancelled:{
            [self completePoint:point percent:percent state:UIGestureRecognizerStateCancelled];
            break;
        }
        default:
            break;
    }
}

- (void)completePoint:(CGPoint)point percent:(CGFloat)percent state:(UIGestureRecognizerState)state {
    self.isPan = NO;
    if ([self point:point percent:percent state:state] >= 0.5) {
        [self finishInteractiveTransition];
    }else {
        [self cancelInteractiveTransition];
    }
}

- (CGFloat)point:(CGPoint)point percent:(CGFloat)percent state:(UIGestureRecognizerState)state {
    if (percent >= 0.5){
     percent = 0.5;
    } else if (percent<=0){
     percent = 0;
    }
    
    self.block(point, percent, state);
    return percent;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint point = [pan translationInView:pan.view];
    if (point.y > 0) return YES;
    return NO;
    
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    
//}
//
// - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer  {
//    
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
//    
//}



- (void)startGesture {
    
    switch (self.transitionStyle) {
        case InteractiveTransitionStylePrensent:
        {
            
        }
            break;
           
        case InteractiveTransitionStyleDismiss:
        {
            [self.pictureViewController dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case InteractiveTransitionStylePush:
        {
            
        }
            break;
        case InteractiveTransitionStylePop:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    
}

@end
