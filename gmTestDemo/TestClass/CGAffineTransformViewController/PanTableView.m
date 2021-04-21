//
//  MYTableView.m
//  apiData
//
//  Created by lemonmgy on     /  /  .
//  Copyright ©     年 lemonmgy. All rights reserved.
//

#import "PanTableView.h"

@interface PanTableView()<UIGestureRecognizerDelegate>

@end

@implementation PanTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
         self.delaysContentTouches = NO;
        self.canCancelContentTouches = NO;
        
        
        self.myPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panClick:)];
        self.myPan.delegate = self;
        [self addGestureRecognizer:self.myPan];
     }
    return  self;
}

- (void)panClick:(UIPanGestureRecognizer *)pan {
    [pan setCancelsTouchesInView:NO];
//    NSLog(@"%lf",[pan translationInView:self].y);
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        { 
            [self.touchDelegate tableView:self touchesBegan:pan];
        }
        case UIGestureRecognizerStateChanged:
        {

            [self.touchDelegate tableView:self touchesMoved:pan];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.touchDelegate tableView:self touchesEnded:pan];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            [self.touchDelegate tableView:self touchesCancelled:pan];
        }
            break;
        default:
            break;
    }
    
//    NSLog(@"%s",__func__);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    switch (gestureRecognizer.state) {
//        case UIGestureRecognizerStateBegan:
//        {
//           UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
//            NSLog(@"x==%f      y==%f",[pan velocityInView:self].x,[pan velocityInView:self].y);
//            CGPoint velocity = [pan velocityInView:self];
//            CGFloat vx = fabs(velocity.x);
//            CGFloat vy = fabs(velocity.y);
//            
//            return (vx < 100 || vy > 20);
//        }
//        case UIGestureRecognizerStateChanged:
//        {
//            
//        }
//            break;
//        case UIGestureRecognizerStateEnded:
//        {
//            
//        }
//            break;
//            
//            
//        default:
//            break;
//    }
    
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return YES;
}
@end
