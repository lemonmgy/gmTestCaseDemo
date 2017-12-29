//
//  MYAnimatedEndViewController.m
//  test
//
//  Created by lemonmgy on 2017/1/19.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYAnimatedEndViewController.h"
#import "MYAnimatedTransitioning.h"
@interface MYAnimatedEndViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation MYAnimatedEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    self.transitioningDelegate = self;
    self.bcakView = [UIView new];
    self.bcakView.backgroundColor = [UIColor blackColor];
    self.bcakView.frame = self.view.frame;
    [self.view addSubview:self.bcakView];
    
    UIImage *image = [UIImage imageNamed:self.imageName];
    
    self.imageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.imageView addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    self.imageView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, image.size.height/image.size.width * kSCREEN_WIDTH);
    self.imageView.center = self.view.center;
    [self.imageView setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:self.imageView];
    
    BOOL ret = CGRectEqualToRect(self.startFrame, CGRectZero);
    if (ret) {
        self.show = YES;
        self.startFrame = CGRectMake((kSCREEN_WIDTH - 100)/2.0, (kSCREEN_HEIGHT- 64 - image.size.height/image.size.width * 100)/2.0, 100, image.size.height/image.size.width * 100);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"deallocdeallocdealloc");
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    MYAnimatedTransitioning *vc = [MYAnimatedTransitioning new];
    vc.operation = UINavigationControllerOperationPush;
    
    return vc;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    MYAnimatedTransitioning *vc = [MYAnimatedTransitioning new];
    vc.operation = UINavigationControllerOperationPop;
    
    return vc;
}



@end
