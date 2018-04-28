//
//  MYEntranceViewController.m
//  test
//
//  Created by lemonmgy on 2017/1/19.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYEntranceViewController.h"
#import "MainViewController.h"

@interface MYEntranceViewController ()

@end

@implementation MYEntranceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor brownColor]];
    self.navigationItem.title = @"测试页面";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看" style:UIBarButtonItemStyleDone target:[MainViewController class] action:@selector(gotoTabBarController)];
}

@end
