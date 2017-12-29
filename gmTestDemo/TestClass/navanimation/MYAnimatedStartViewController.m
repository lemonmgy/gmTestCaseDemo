
//
//  MYFirstViewController.m
//  test
//
//  Created by lemonmgy on 2017/1/9.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYAnimatedStartViewController.h"
#import "MYAnimatedEndViewController.h"
#import "MYAnimatedTransitioning.h"

@interface MYAnimatedStartViewController ()
@property (nonatomic, strong) NSMutableArray *iconArr;
@end

@implementation MYAnimatedStartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.iconArr = [NSMutableArray new];
    


    for (int i = 0; i < 5; i ++) {
        UIButton *btn = [self getBtn];
        btn.tag = i;
        
        NSString *iconName = [NSString stringWithFormat:@"icon%d",i];
        [self.iconArr addObject:iconName];
        UIImage *image = [UIImage imageNamed:iconName];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
         btn.frame = CGRectMake(i*20, i*20, 100, image.size.height/image.size.width*100.0);
        [self.view addSubview:btn];
     }
}

- (UIButton *)getBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(goButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panClick:)];
    [btn addGestureRecognizer:pan];
    
    return btn;
}

- (void)panClick:(UIPanGestureRecognizer *)pan {
    
    CGPoint point = [pan locationInView:self.view];
    pan.view.center = point;
//    if (pan.state == UIGestureRecognizerStateBegan ||
//        pan.state == UIGestureRecognizerStateChanged) {
//        
//    }else if (pan.state == UIGestureRecognizerStateEnded||
//              pan.state == UIGestureRecognizerStateCancelled) {
//
//    }

}
- (void)goButtonClick:(UIButton *)sender {
    
   MYAnimatedEndViewController *vc = [MYAnimatedEndViewController new];
    vc.imageName = self.iconArr[sender.tag];
    vc.startFrame = sender.frame;
    [self presentViewController:vc animated:YES completion:nil];
    
} 


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
