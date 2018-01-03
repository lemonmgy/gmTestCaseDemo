//
//  GMTimerViewController.m
//  gmTestDemo
//
//  Created by lemonmgy on 2018/1/2.
//  Copyright © 2018年 lemonmgy. All rights reserved.
//

#import "GMTimerViewController.h"

@interface GMTimerViewController ()
@property (nonatomic, strong) CADisplayLink *display;
@end

@implementation GMTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *sender = [UIButton buttonWithType:UIButtonTypeSystem];
    sender.backgroundColor = [UIColor redColor];
    [sender addTarget:self action:@selector(senderClick) forControlEvents:UIControlEventTouchUpInside];
    sender.frame = CGRectMake(0, 0, 200, 200);
    [self.view addSubview:sender];
}

- (void)senderClick {
    
    NSLog(@"点击了按钮");
    self.display = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayClick:)];
//    self.display.frameInterval = 6;
    [self.display addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //[self.display invalidate];
}
- (void)displayClick:(CADisplayLink *)display {
    static int i = 0;
    NSLog(@"%d",i++);
}


@end
