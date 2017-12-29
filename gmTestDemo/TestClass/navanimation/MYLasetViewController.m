//
//  MYLasetViewController.m
//  test
//
//  Created by lemonmgy on 2017/1/5.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYLasetViewController.h"

@interface MYLasetViewController ()

@end

@implementation MYLasetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIButton  *btn =[UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [btn setTitle:@"返回" forState:UIControlStateNormal];
//    
//    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    
//    btn.frame=CGRectMake(0, 0, 60, 40);
//    
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    
//    UIBarButtonItem  *item =[[UIBarButtonItem alloc]initWithCustomView:btn];
//    
//    self.navigationItem.leftBarButtonItem=item;
//    
//    
//    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    
    
    NSInteger num = self.navigationController.viewControllers.count;
    self.navigationItem.title = [NSString stringWithFormat:@"%ld",(long)num];
    self.view.backgroundColor = [UIColor redColor];
    
    self.tableView.backgroundColor = [UIColor purpleColor];
    for (int i = 0 ; i <10; i++) {
        [self.tableViewDataArr addObject:[NSString stringWithFormat:@"%@---%d",self.navigationItem.title,i]];
    }
    
    
    
}
- (void)back{
 [self.navigationController popViewControllerAnimated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//        [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 
@end
