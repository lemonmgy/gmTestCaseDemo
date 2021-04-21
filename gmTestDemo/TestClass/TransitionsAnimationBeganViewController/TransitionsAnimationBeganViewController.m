
//
//  MYPresentationController.m
//  test
//
//  Created by lemonmgy on 16/10/27.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import "TransitionsAnimationBeganViewController.h"
//转场动画
@interface MyPresentationConytollrt()
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic,strong) void(^hidssView)(void);
@end


@interface MyPresentationConytollrt ()

@end

@implementation MyPresentationConytollrt

-(void)dealloc
{
    
}
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    if ((self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController])) {
        _dimmingView = [[UIView alloc] init];
        _dimmingView.backgroundColor = [UIColor redColor];
        _dimmingView.alpha = 0;
    }
    return self;
}

//页面进入的时候调用
- (void)presentationTransitionWillBegin
{
    _dimmingView.frame = self.containerView.bounds;
    //    [self.containerView addSubview:_dimmingView];
    [self.containerView addSubview:self.presentedView];
    
    self.presentedView.alpha = 0;
    
    id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

- (void)presentationTransitionDidEnd:(BOOL)completed
{
    if (!completed) {
        [_dimmingView removeFromSuperview];
    }
}
//页面消失的时候调用

- (void)dismissalTransitionWillBegin
{
    id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if (completed) {
        [_dimmingView removeFromSuperview];
    }
}

//改变页面的frame
//- (CGRect)frameOfPresentedViewInContainerView
//{
//    CGRect frame = self.containerView.bounds;
//    frame.origin.x = CGRectGetWidth([UIScreen mainScreen].bounds);
//    frame = CGRectInset(CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2.0, CGRectGetHeight([UIScreen mainScreen].bounds)/2.0, 100, 100), 0, 0);
//
//
////    return CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2.0, CGRectGetHeight([UIScreen mainScreen].bounds)/2.0, 100, 100);
//
//    return  CGRectMake(100, 200, 200, 300);
//}

@end



@interface TransitionsAnimationEndViewController ()<UIViewControllerTransitioningDelegate>

@end
@implementation TransitionsAnimationEndViewController
- (instancetype)init
{
    if ((self = [super init]))  {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.frame = CGRectMake(0, 0, 100, 30);
    close.center = self.view.center;
    [close setTitle:@"退出" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:1 animations:^{
        self.view.alpha = 1;
    }];
}

- (void)closeAction:(UIButton *)sender
{
    [UIView animateWithDuration:1 animations:^{
        self.view.alpha = 0;
    }completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:^{
        }];
    }];
    
    
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    if (presented == self) {
        MyPresentationConytollrt *presen = [[MyPresentationConytollrt alloc] initWithPresentedViewController:presented presentingViewController:presenting];
        
        return presen;
    }
    return nil;
}

@end


@implementation TransitionsAnimationBeganViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor brownColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 100, 100)];
    btn.backgroundColor = [UIColor yellowColor];
    [btn addTarget:self action:@selector(btnnnn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)btnnnn{
    TransitionsAnimationEndViewController *testVC = [[TransitionsAnimationEndViewController alloc] init];
    [self presentViewController:testVC animated:NO completion:^{}];
}
@end
