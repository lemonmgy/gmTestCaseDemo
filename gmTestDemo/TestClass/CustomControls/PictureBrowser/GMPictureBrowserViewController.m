//
//  GMPictureBrowserViewController.m
//  test
//
//  Created by lemonmgy on 2017/1/20.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "GMPictureBrowserViewController.h"
#import "GMImageAnimatedTransitioning.h"
#import "GMInteractiveTransition.h"
#import "GMPostTableViewCell.h"
#import "GMPictureSwitchView.h"
#import "GMIconItem.h"


@interface GMPictureBrowserViewController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) GMInteractiveTransition *interactiveTransition;
@property (nonatomic, assign) CGRect clickRect;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIView *leftCurtain;
@property (nonatomic, strong) UIView *rightCurtain;
@property (nonatomic, strong) UIView *topCurtain;
@property (nonatomic, strong) UIView *bottomCurtain;
@property (nonatomic, assign)  BOOL localPhotoAlbum;//是否本地相册
@end



@implementation GMPictureBrowserViewController
- (BOOL)localPhotoAlbum {
    if ([[self.iconItemArray lastObject] smallImage]) {
        return YES;
    }else {
        return NO;
    }
}

- (void)dealloc {
    //    [SDImageCache ]
    NSLog(@"dealloc----->>>%@<<<-----dealloc",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.transitioningDelegate = self;
    
    self.backView = [UIView new];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.frame = self.view.frame;
    [self.view addSubview:self.backView];
    
    self.switchView = [GMPictureSwitchView new];
    self.switchView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    [self.switchView refreshDataSource:self.iconItemArray currentIndex:self.currentIndex];
    __weak __typeof (self) weakSelf = self;
    self.switchView.shufflingCallBackBlock = ^(GMIconItem *obj, NSInteger currentIndex, GMShufflingBlockType type) {
        if (type == GMShufflingBlockTypeWithExit) {
            [weakSelf dismiss];
        }
        weakSelf.currentIndex = currentIndex;
    };
    self.switchView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.switchView];
    
    
    [self mirrorViewLayout];//动画
    
    
    BOOL open = YES;
    if (open){//手势
        self.interactiveTransition = [GMInteractiveTransition new];
        self.interactiveTransition.transitionStyle = InteractiveTransitionStyleDismiss;
        self.interactiveTransition.pictureViewController = self;
        [self.interactiveTransition addGestureRecognizerWithView:self.switchView.imageScrollView];
        
        __weak __typeof (self) weakSelf = self;
        __block CGAffineTransform transform = CGAffineTransformIdentity;
        [self.interactiveTransition setBlock:^(CGPoint point, CGFloat percent, UIGestureRecognizerState state) {
            transform = CGAffineTransformIdentity;
            transform = CGAffineTransformScale(transform, 1-percent,1-percent);
            transform = CGAffineTransformTranslate(transform, point.x, point.y);
            weakSelf.mirrorBottomView.transform = transform;
            
            //            weakSelf.mirrorBottomView.hidden = NO;
            //            weakSelf.switchView.hidden = YES;
            //            if (state == UIGestureRecognizerStateEnded  ||
            //                state == UIGestureRecognizerStateCancelled) {
            //                weakSelf.switchView.hidden = NO;
            //                weakSelf.mirrorBottomView.hidden = YES;
            //            }
            //            goBack
        }];
    }
    
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    GMImageAnimatedTransitioning *vc = [GMImageAnimatedTransitioning new];
    vc.operation = UINavigationControllerOperationPush;
    return vc;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    GMImageAnimatedTransitioning *vc = [GMImageAnimatedTransitioning new];
    vc.operation = UINavigationControllerOperationPop;
    return vc;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.interactiveTransition.isPan ? self.interactiveTransition : nil;
}

- (CGAffineTransform)relativeRectAnimatTransformWithStartRect:(CGRect)startRect andEndRect:(CGRect)endRect {
    return [self animatTransformWithStartRect:startRect andEndRect:endRect];
}

- (CGAffineTransform)animatTransformWithStartRect:(CGRect)startRect andEndRect:(CGRect)endRect {
    if (CGRectEqualToRect(endRect, CGRectZero)) {
        endRect = CGRectMake(kSCREEN_WIDTH/2.0, kSCREEN_HEIGHT/2.0, 0, 0);
    }
    
    CGFloat startCenterX = [self superviewCenter:startRect].x;
    CGFloat startCenterY = [self superviewCenter:startRect].y;
    CGFloat endCenterX = [self superviewCenter:endRect].x;
    CGFloat endCenterY = [self superviewCenter:endRect].y;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, endCenterX-startCenterX, endCenterY - startCenterY);
    transform = CGAffineTransformScale(transform, endRect.size.width/startRect.size.width, endRect.size.height/startRect.size.height);
    return transform;
}

- (CGPoint)superviewCenter:(CGRect)rect {
    return CGPointMake(rect.origin.x + rect.size.width/2.0, rect.origin.y + rect.size.height/2.0);
}

- (CGPoint)selfCenter:(CGRect)rect {
    return CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
}

- (void)setBackViewAlpha:(CGFloat)backViewAlpha {
    _backViewAlpha = backViewAlpha;
    self.backView.alpha = backViewAlpha;
    //    self.topCurtain.alpha = backViewAlpha;
    //    self.leftCurtain.alpha = backViewAlpha;
    //    self.bottomCurtain.alpha = backViewAlpha;
    //    self.rightCurtain.alpha = backViewAlpha;
}


- (void)curtain {
    if (self.topCurtain == nil) {
        
        
        self.topCurtain = [UIView new];
        self.topCurtain.backgroundColor = self.backView.backgroundColor;
        [self.mirrorBottomView addSubview:self.topCurtain];
        
        self.leftCurtain = [UIView new];
        self.leftCurtain.backgroundColor = self.topCurtain.backgroundColor;
        [self.mirrorBottomView addSubview:self.leftCurtain];
        
        self.bottomCurtain = [UIView new];
        self.bottomCurtain.backgroundColor = self.topCurtain.backgroundColor;
        [self.mirrorBottomView addSubview:self.bottomCurtain];
        
        self.rightCurtain = [UIView new];
        self.rightCurtain.backgroundColor = self.topCurtain.backgroundColor;
        [self.mirrorBottomView addSubview:self.rightCurtain];
        [self curtainSetFrame:YES transform:NO hidden:NO];
        
        //        self.topCurtain.backgroundColor = [UIColor greenColor];
        //        self.leftCurtain.backgroundColor = [UIColor yellowColor];
        //        self.bottomCurtain.backgroundColor = [UIColor blueColor];
        //        self.rightCurtain.backgroundColor = [UIColor orangeColor];
    }
    
}

- (void)curtainSetFrame:(BOOL)frame transform:(BOOL)transform hidden:(BOOL)hidden {
    [self curtainFrame:frame];
    [self curtainTransform:transform];
    [self curtainHidden:hidden];
}

- (void)curtainFrame:(BOOL)frame {
    if (frame) {
        [self curtainTransform:NO];
        
        CGSize topContentSize = self.mirrorTopView.frame.size;
        CGSize contentSize = self.mirrorBottomView.frame.size;
        
        CGFloat width  = (contentSize.width - topContentSize.width)/2.0;
        CGFloat height = (contentSize.height - topContentSize.height)/2.0;
        
        self.topCurtain.frame = CGRectMake(0, 0, contentSize.width, height);
        self.leftCurtain.frame = CGRectMake(0, 0, width, contentSize.height);
        self.bottomCurtain.frame = CGRectMake(0, contentSize.height-height, contentSize.width, height);
        self.rightCurtain.frame = CGRectMake(contentSize.width - width, 0, width, contentSize.height);
    }
}

- (void)curtainTransform:(BOOL)transform {
    if (transform) {
        self.topCurtain.transform = CGAffineTransformMakeTranslation(0, -self.topCurtain.frame.size.height);
        self.leftCurtain.transform = CGAffineTransformMakeTranslation(-self.leftCurtain.frame.size.height, 0);
        self.bottomCurtain.transform = CGAffineTransformMakeTranslation(0, self.bottomCurtain.frame.size.height);
        self.rightCurtain.transform = CGAffineTransformMakeTranslation(self.rightCurtain.frame.size.height, 0);
    }else {
        self.topCurtain.transform = CGAffineTransformIdentity;
        self.leftCurtain.transform = CGAffineTransformIdentity;
        self.bottomCurtain.transform = CGAffineTransformIdentity;
        self.rightCurtain.transform = CGAffineTransformIdentity;
    }
}
- (void)curtainHidden:(BOOL)hidden {
    
    self.topCurtain.hidden = hidden;
    self.leftCurtain.hidden = hidden;
    self.bottomCurtain.hidden = hidden;
    self.rightCurtain.hidden = hidden;
    
    if (!hidden) {
        [self.bottomCurtain bringSubviewToFront:self.topCurtain];
        [self.bottomCurtain bringSubviewToFront:self.bottomCurtain];
        [self.bottomCurtain bringSubviewToFront:self.leftCurtain];
        [self.bottomCurtain bringSubviewToFront:self.rightCurtain];
    }
}
#pragma mark--get

- (BOOL)mirrorTransformWithEntering:(BOOL)entering andAllow:(BOOL)allow {
    
    BOOL inside = CGRectIntersectsRect(self.view.bounds,self.clickViewFrame);
    if (!allow) return inside;
    if (!inside) return NO;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (entering) {
        CGFloat x = self.clickViewFrame.origin.x;
        CGFloat y = self.clickViewFrame.origin.y;
        CGFloat width = self.clickViewFrame.size.width;
        CGFloat height = self.clickViewFrame.size.height;
        CGFloat tempWidth = width;
        CGFloat tempHeight = height;
        
        CGRect rect  = CGRectZero;
        
        
        CGFloat imageW = self.mirrorBottomView.image.size.width;
        CGFloat imageH = self.mirrorBottomView.image.size.height;
        
        if (imageW > imageH) {
            tempHeight = height;
            tempWidth = tempHeight *imageW/imageH *1.0;
            
            rect = CGRectMake(x - (tempWidth-self.clickViewFrame.size.width)/2.0, y, tempWidth, tempHeight);
        }else {
            tempWidth = width;
            tempHeight = tempWidth * imageH/imageW *1.0;
            CGFloat border = tempWidth * kSCREEN_HEIGHT/kSCREEN_WIDTH;
            if (tempHeight >= border) tempHeight = border;
            rect = CGRectMake(x, y-(tempHeight-height)/2.0, tempWidth, tempHeight);
        }
        
        transform = [self relativeRectAnimatTransformWithStartRect:self.mirrorBottomView.frame andEndRect:rect];
    }else {
        transform = [self relativeRectAnimatTransformWithStartRect:self.mirrorBottomView.frame andEndRect:self.clickViewFrame];
    }
    self.mirrorBottomView.transform = transform;
    self.mirrorTopView.transform = [self relativeRectAnimatTransformWithStartRect:self.mirrorTopView.frame andEndRect:self.clickViewFrame];
    
    return YES;
}

- (void)mirrorTransformWithIdentity {
    self.mirrorBottomView.transform = CGAffineTransformIdentity;
    self.mirrorTopView.transform = CGAffineTransformIdentity;
}

- (void)mirrorViewLayout {
    if (self.mirrorBottomView == nil) {
        self.mirrorBottomView = [UIImageView new];
        self.mirrorBottomView.userInteractionEnabled = YES;
        self.mirrorBottomView.backgroundColor = [UIColor clearColor];
        self.mirrorBottomView.layer.masksToBounds = YES;
        [self.view addSubview:self.mirrorBottomView];
        
        self.mirrorTopView = [UIImageView new];
        self.mirrorTopView.backgroundColor = [UIColor clearColor];
        self.mirrorTopView.layer.masksToBounds = YES;
        self.mirrorTopView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:self.mirrorTopView];
    }
    [self mirrorTransformWithIdentity];
    
    if (self.localPhotoAlbum) {
        UIImage *image = [self getCurrentZoomIcon:NO];
        self.mirrorTopView.image = image;
        self.mirrorBottomView.image = image;
        [self layoutMirrorView:image];

    }else {
    UIImage *image = [self getCurrentZoomIcon:NO];
    if (!image) image = [self getCurrentZoomIcon:YES];
        if (image) {
            self.mirrorTopView.image = image;
            self.mirrorBottomView.image = image;
            [self layoutMirrorView:image];
        }
    }
}

- (void)layoutMirrorView:(UIImage *)image {
    if (image.size.height <= 0 || image.size.width <= 0) {
        return;
    }
    
    //frame
    self.mirrorBottomView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, image.size.height/image.size.width * kSCREEN_WIDTH);
    
    BOOL retW = image.size.width > image.size.height;
    CGFloat baseValue = retW ? self.mirrorBottomView.frame.size.height:self.mirrorBottomView.frame.size.width;
    if (baseValue >= kSCREEN_WIDTH) baseValue = kSCREEN_WIDTH;
    CGFloat w2 = 1 * baseValue;
    CGFloat h2 = 1 * baseValue;
    self.mirrorTopView.bounds =CGRectMake(0, 0, w2, h2);
    
    CGFloat height = kSCREEN_HEIGHT;
    if (self.mirrorBottomView.frame.size.height > kSCREEN_HEIGHT) {
        height = self.mirrorBottomView.frame.size.height;
    }
    self.mirrorBottomView.center = [self selfCenter:CGRectMake(0, 0, kSCREEN_WIDTH, height)];
    self.mirrorTopView.center = self.mirrorBottomView.center;
    [self curtain];//展开视图
}
//ret 为yes则小图，NO为大图
- (UIImage *)getCurrentZoomIcon:(BOOL)ret {
    if (self.currentIndex < self.iconItemArray.count) {
        if (!self.localPhotoAlbum) {//Image
            NSString *iconUrl = ret ? [self.iconItemArray[self.currentIndex] smallIconUrl] : [self.iconItemArray[self.currentIndex] bigIconUrl];
            return [GMIconItem imageFromCacheForKey:iconUrl];;
        }else {//Image
            return [self.iconItemArray[self.currentIndex] smallImage];
        }
    }
    return nil;
}

- (BOOL)isPan {
    return self.interactiveTransition.isPan;
}

- (CGRect)clickViewFrame {
    
    //    CGRect temprect = [self.iconItemArray[self.currentIndex] iconRect];
    CGRect temprect = [self.iconItemArray[self.currentIndex] thumbView].frame;
    if (CGRectEqualToRect(_clickViewFrame, CGRectZero) ||
        !CGRectEqualToRect(self.clickRect, temprect)) {
        self.clickRect = temprect;
        _clickViewFrame = [self.clickCell convertRect:temprect toView:self.view];
        NSLog(@"CGRectEqualToRectCGRectEqualToRectCGRectEqualToRect");
    }
    
    return _clickViewFrame;
}

- (void)setHiddenOutIcon:(BOOL)hiddenOutIcon {
    _hiddenOutIcon = hiddenOutIcon;
    for (GMIconItem *item in self.iconItemArray) {
        item.thumbView.hidden = NO;
    }
    [self.iconItemArray[self.currentIndex] thumbView].hidden = _hiddenOutIcon;
}

@end
