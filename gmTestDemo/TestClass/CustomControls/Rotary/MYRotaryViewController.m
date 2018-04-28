//
//  MYRotaryViewController.m
//  test
//
//  Created by lemonmgy on 2017/1/19.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYRotaryViewController.h"

#import "myview.h"
#import "MYRotaryView.h"

@interface MYRotaryViewController ()

@end

@implementation MYRotaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    {
        UIButton *btn = [UIButton new];
        btn.backgroundColor = [UIColor purpleColor];
        btn.frame = CGRectMake(0, 0, 50, 50);
        [self.view addSubview:btn];
        [btn setTitle:@"pop" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    {
        UIButton *btn = [UIButton new];
        btn.backgroundColor = [UIColor purpleColor];
        btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 0, 50, 50);
        [self.view addSubview:btn];
        [btn setTitle:@"push" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    {
        UIButton *btn = [UIButton new];
        btn.backgroundColor = [UIColor purpleColor];
        btn.frame = CGRectMake(0, 0, 50, 50);
        btn.center = CGPointMake(self.view.center.x, btn.center.y);
        [self.view addSubview:btn];
        [btn setTitle:@"switch" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btn3Click:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void)btn3Click:(UIButton *)sender {
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            
        }else {
            [view removeFromSuperview];
        }
    }
    
    if ((sender.tag = !sender.tag)) {
        myview *view = [[myview alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
        view.center = self.view.center;
        view.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:view];
        
    }else {
        CGFloat w = 1.3*[UIScreen mainScreen].bounds.size.width;
        MYRotaryView *view = [[MYRotaryView alloc]initWithFrame:CGRectMake(0, 0, w, w)];
        
        view.block = ^(NSString *title){
            [sender setTitle:title forState:UIControlStateNormal];
        };
        
        view.center = CGPointMake(self.view.center.x, self.view.center.y);
        view.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:view];
    }
    
    
    
}

- (void)btn2Click {
    [self presentViewController:[[self class] new] animated:YES completion:nil];
}

- (void)btnClick {
    if (![self.presentingViewController isKindOfClass:[UITabBarController class]]) {
        show_alert(@"到头了");
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
