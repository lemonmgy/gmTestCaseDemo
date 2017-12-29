//
//  MYBezierPathViewController.m
//  test
//
//  Created by lemonmgy on 2016/11/4.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import "MYBezierPathViewController.h"


static CGFloat line;
@interface MYView :UIView

@end


@implementation MYView



- (void)drawRect:(CGRect)rect
{
    
    
    
    UIBezierPath *backpath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(200, 200) radius:50 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    backpath.lineWidth = 2;
    
    
    [[UIColor redColor] set];
    [backpath fill];
    [backpath stroke];
    
    
    
    //    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(200, 200) radius:50 startAngle:0 endAngle:(M_PI*line/180) clockwise:YES];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(200, 200)];
    [path addArcWithCenter:CGPointMake(200, 200) radius:50 startAngle:0 endAngle:(M_PI*line/180) clockwise:YES];
    [path closePath];
    //    - (void)addArcWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise NS_AVAILABLE_IOS(4_0);
    
    
    line ++;
    
    // 最后的闭合线是可以通过调用closePath方法来自动生成的，也可以调用-addLineToPoint:方法来添加
    //  [path addLineToPoint:CGPointMake(20, 20)];
    
    // 设置线宽
    path.lineWidth = 2;
    
    // 设置填充颜色
    UIColor *fillColor = [UIColor blueColor];
    [fillColor set];
    [path fill];
    
    // 设置画笔颜色
    UIColor *strokeColor = [UIColor blueColor];
    [strokeColor set];
    
    // 根据我们设置的各个点连线
    [path stroke];
    
}

@end


@interface MYBezierPathViewController ()
{
    CADisplayLink *_link;
}

@end

@implementation MYBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view = [[MYView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    self.topItemNameArr = @[@"开始",@"结束"];
    
    
}

- (void)topButtonClick:(UIBarButtonItem *)sender  {
    if (sender.tag == 0) {
        [_link invalidate];
        _link = nil;
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLink)];
        [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        _link = link;
    }else {
        [_link invalidate];
        _link = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_link) {
        [_link invalidate];
        _link = nil;
    }
    
}

- (void)displayLink{
    
    
    if (line == 360) {
    [_link invalidate];
        _link = nil;

        return;
    }
    NSLog(@"%lf",line);
    [self.view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
