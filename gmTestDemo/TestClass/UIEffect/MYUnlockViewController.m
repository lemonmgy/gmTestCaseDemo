//
//  MYUnlockViewController.m
//  test
//
//  Created by lemonmgy on 2017/1/4.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "MYUnlockViewController.h"
#import <objc/runtime.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface MYUnlockView : UIView


@property (nonatomic, copy) void (^completeBlock)(NSString *string);
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) NSMutableArray *selectedBtnArr;
@property (nonatomic, copy)   NSString *code;
@property (nonatomic, assign) CGPoint currentPoint;
@end

@implementation MYUnlockView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self createUnlockViewInternalUi];
    }
    return self;
}

#pragma mark --初始化控件
- (void)createUnlockViewInternalUi
{
    self.btnArr = [NSMutableArray new];
    self.selectedBtnArr = [NSMutableArray new];
    CGFloat w = 50;
    CGFloat spacing = ([UIScreen mainScreen].bounds.size.width - 3*w)/4.0;
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [self getBtn];
        btn.frame = CGRectMake((i%3)*(spacing+w)+spacing, i/3 *(w +20), w, w);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = w/2.0;
        btn.tag = i+1;
        [self addSubview:btn];
        [self.btnArr addObject:btn];
    }
}

- (UIButton *)getBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.userInteractionEnabled = NO;
    [btn setImage:[UIImage imageNamed:@"icon2"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon9"] forState:UIControlStateSelected];
    return btn;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (self.selectedBtnArr.count) {
        
        UIButton *tempbtn = [self.selectedBtnArr firstObject];
        CGContextMoveToPoint(ctx, tempbtn.center.x, tempbtn.center.y);
        
        for (UIButton *btn in self.selectedBtnArr) {
            if (btn == tempbtn) continue;
            CGContextAddLineToPoint(ctx, btn.center.x, btn.center.y);
        }
        
        CGContextAddLineToPoint(ctx, self.currentPoint.x, self.currentPoint.y);
        
    }else {
        CGContextMoveToPoint(ctx, self.currentPoint.x, self.currentPoint.y);
    }
    CGContextStrokePath(ctx);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.code = @"";
    [self addWithTouch:[touches anyObject]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self addWithTouch:[touches anyObject]];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self reset];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setMyCode];
    if (self.completeBlock) {
        self.completeBlock(self.code);
    }
}

- (void)addWithTouch:(UITouch *)touch {
    CGPoint touchPoint = [touch locationInView:self];
    for (UIButton *btn in self.btnArr) {
        if (CGRectContainsPoint(btn.frame, touchPoint)&&![self.selectedBtnArr containsObject:btn]) {
            btn.selected = YES;
            [self.selectedBtnArr addObject:btn];
        }
    }
    self.currentPoint = touchPoint;
    if (self.selectedBtnArr.count) [self setNeedsDisplay];
}

- (void)reset {
    for (UIButton *btn in self.btnArr) {
        btn.selected = NO;
    }
    self.currentPoint = CGPointZero;
    [self.selectedBtnArr removeAllObjects];
    [self setNeedsDisplay];
}

- (void)setMyCode {
    for (UIButton *tempbtn in self.selectedBtnArr) {
        self.code = [NSString stringWithFormat:@"%@%ld",self.code,(long)tempbtn.tag];
    }
    if (self.code.length <6) {
        self.code = @"";
    }
}

@end


@interface MYUnlockViewController ()
@property (nonatomic, strong) MYUnlockView *myview;
@end

@implementation MYUnlockViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self unlockView];
//    [self touchId];
}

- (void)unlockView{
    
    if (![self getInfoCode]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设置手势密码" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    self.myview = [[MYUnlockView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)];
    self.myview.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.myview];
    static int i = 3;
    __weak __typeof (self) weakSelf = self;
    self.myview.completeBlock = ^(NSString *code) {
        
        //        indicator
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.frame = CGRectMake(100, 100, 100, 100);
        [weakSelf.view addSubview:indicator];
        [indicator startAnimating];
        weakSelf.myview.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.myview.userInteractionEnabled = YES;
            [indicator stopAnimating];
            [indicator removeFromSuperview];
            [weakSelf.myview  reset];
            UILabel *label = objc_getAssociatedObject(weakSelf, @"label");
            label.text = code;
            if (!code.length) {
                [weakSelf alertString:@"请重新输入"];
                return;
            }
            NSString *myCode = [weakSelf getInfoCode];
            i -=1;
            if ([myCode isEqualToString:code]) {
                i = 3;
                [weakSelf alertString:[NSString stringWithFormat:@"成功%d",i]];
            }else if (i == 0) {
                [weakSelf alertString:[NSString stringWithFormat:@"错误次数达到上限%d",i]];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user removeObjectForKey:@"code"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else if (!myCode) {
                [weakSelf alertString:@"设置成功"];
                [weakSelf saveInfoCode:code];
            }
            
        });
    };
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.myview.frame) + 20, [UIScreen mainScreen].bounds.size.width, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [label addGestureRecognizer:tap];
    label.userInteractionEnabled = YES;
    objc_setAssociatedObject(self, @"label", label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (void)tapClick {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"code"];
    [self alertString:@"删除成功"];
}

- (void)saveInfoCode:(NSString *)code {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:code forKey:@"code"];
    [user synchronize];
    
}

- (NSString *)getInfoCode {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *code = [user objectForKey:@"code"];
    return code.length? code:nil;
}
- (void)alertString:(NSString *)string {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}

-(void)dealloc {
    NSLog(@"deallocdeallocdeallocdealloc");
    objc_removeAssociatedObjects(self);
}


- (void)touchId {
    LAContext *lac = [[LAContext alloc]init];
    lac.localizedCancelTitle = @"设置";
    NSError *error = nil;
    if ([lac canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [lac evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"想" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                
            }else {
                
            }
            
        }];
        
    }
    
    NSLog(@"%@",error);

    
}

- (void)text3d {
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
