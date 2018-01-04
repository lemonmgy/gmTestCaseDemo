//
//  GMObserverViewController.m
//  gmTestDemo
//
//  Created by lemonmgy on 2018/1/3.
//  Copyright © 2018年 lemonmgy. All rights reserved.
//

#import "GMObserverViewController.h"


@interface GMObserverViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;


@end

@implementation GMObserverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    self.label.text = @"你好吗";
    [self.view addSubview:self.label];
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(100, 200, 300, 300);
    self.button.backgroundColor = [UIColor purpleColor];
    [self.button setTitle:@"点我，快点" forState:UIControlStateNormal];
    [self.button addTarget: self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    
    [self.label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"woshiyitouzhu"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@",context);
}

- (void)buttonClick {
    int i = arc4random()%100;
    self.label.text = [NSString stringWithFormat:@"%d",i];
}


@end
