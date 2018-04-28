//
//  MYNavigationController.m
//  test
//
//  Created by lemonmgy on 2017/1/6.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYNavigationController.h"
#import "MYAnimatedTransitioning.h"
@interface MYNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation MYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.navigationBar setBackgroundImage:[self imageWithColor:[UIColor orangeColor]] forBarMetrics:UIBarMetricsDefault];
    self.interactivePopGestureRecognizer.delegate = self;
} 

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        UIImage *arrowLeftImage = [[UIImage imageNamed:@"arrow_left"]
                                   imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc]
         initWithImage:arrowLeftImage
         style:UIBarButtonItemStylePlain
         target:self
         action:@selector(popViewControllerAnimated:)];
        viewController.hidesBottomBarWhenPushed = YES;
         
    }

    [super pushViewController:viewController animated:animated];
}


- (UIImage *)imageWithColor:(UIColor *)color
{
    
    CGSize size = CGSizeMake(1.0f, 1.0f);
    
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}



- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController   {

    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        NSLog(@"UINavigationControllerOperationPush");
    }else if (operation == UINavigationControllerOperationPop){
        NSLog(@"UINavigationControllerOperationPop");
    }
    
    MYAnimatedTransitioning *obj = [MYAnimatedTransitioning new];
    obj.operation = operation;
    return obj;
}



@end
