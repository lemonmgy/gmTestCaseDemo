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
  
}

- (void)topButtonClick:(UIBarButtonItem *)sender {
    
    [self.navigationController pushViewController:[NSClassFromString(@"GMHitViewViewController") new] animated:YES];
    
}


@end
