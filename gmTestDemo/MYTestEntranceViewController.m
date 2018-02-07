//
//  MYTestEntranceViewController.m
//  test
//
//  Created by lemonmgy on 2017/1/20.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYTestEntranceViewController.h"
#import "BrokenLineView.h"
#import "MYCalendarViewController.h"
#import "UIButton+YX.h"

@interface MYTestEntranceViewController (){
    dispatch_source_t _source;
    int i;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;


@end

@implementation MYTestEntranceViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topItemNameArr = (NSMutableArray *)@[@"加载",@"开始"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 100, 150, 150);
    //    btn.center = self.view.center;
    [btn addTarget:self action:@selector(bottomClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    [btn expandClickAreaWithTop:20 left:20 bottom:50 right:50];
    {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(100, 100, 200, 200);
        //    btn.center = self.view.center;
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn.backgroundColor = [UIColor greenColor];
        
    }
    
    
}

- (void)btnClick {
    NSLog(@"btnClick");
}


- (void)bottomClick {
    NSLog(@"bottomClick");
}

- (void)topButtonClick:(UIBarButtonItem *)sender {
    [self.navigationController pushViewController:[NSClassFromString(@"GMObserverViewController") new] animated:YES];
    
}


@end
