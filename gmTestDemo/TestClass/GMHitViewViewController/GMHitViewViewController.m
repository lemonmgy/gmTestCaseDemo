//
//  GMHitViewViewController.m
//  gmTestDemo
//
//  Created by lemonmgy on 2017/12/29.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "GMHitViewViewController.h"
#import "GMHitBackView.h"
#import "GMHitCenterView.h"
#import "GMHitBackButton.h"

@interface GMHitViewViewController ()
@property (nonatomic, strong) GMHitBackView *backView;
@property (nonatomic, strong) GMHitCenterView *centerView;
@property (nonatomic, strong) GMHitBackButton *centerButton;

@end

@implementation GMHitViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    GMHitBackView *backView = [[GMHitBackView alloc] initWithFrame:CGRectMake(50, 200, 200, 200)];
    backView.backgroundColor = [UIColor redColor];
    self.backView = backView;
    [self.view addSubview:backView];
    
    GMHitCenterView *centerView = [[GMHitCenterView alloc] initWithFrame:CGRectMake(50, 0, 100, 100)];
    centerView.backgroundColor = [UIColor purpleColor];
    self.centerView = centerView;
    [backView addSubview:centerView];

    GMHitBackButton *centerButton = [[GMHitBackButton alloc] initWithFrame:CGRectMake(0, 50, 150, 50)];
    centerButton.backgroundColor = [UIColor orangeColor];
    self.centerButton = centerButton;
    [centerView addSubview:centerButton];
    [centerButton addTarget:self action:@selector(centerButtonClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)centerButtonClick:(UIButton *)sender {
    NSLog(@"最后响应者 %@",sender.class);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"最后响应者 %@",event);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
