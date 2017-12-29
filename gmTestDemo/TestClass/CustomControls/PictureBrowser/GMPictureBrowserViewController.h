//
//  GMPictureBrowserViewController.h
//  test
//
//  Created by lemonmgy on 2017/1/20.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GMPictureSwitchView;
@class GMIconItem;

@interface GMPictureBrowserViewController : UIViewController

//必传
@property (nonatomic, strong) NSArray <GMIconItem *>*iconItemArray;//model
@property (nonatomic, assign) NSInteger currentIndex;//当前选中的index
@property (nonatomic, weak)   UIView *clickCell;



//外部调用
@property (nonatomic, assign) CGRect clickViewFrame;
@property (nonatomic, strong) UIImageView *mirrorBottomView;
@property (nonatomic, strong) UIImageView *mirrorTopView;
@property (nonatomic, assign) BOOL hiddenOutIcon;

- (void)mirrorViewLayout;
- (void)mirrorTransformWithIdentity;
//entering 进入控制器/退出控制器时，allow是否允许进行变换  //返回值点击的视图是否在屏幕内
- (BOOL)mirrorTransformWithEntering:(BOOL)entering andAllow:(BOOL)allow;

@property (nonatomic, assign) CGFloat backViewAlpha;
@property (nonatomic, strong) GMPictureSwitchView *switchView;
@property (nonatomic, assign) BOOL isPan;

- (void)curtainSetFrame:(BOOL)frame transform:(BOOL)transform hidden:(BOOL)hidden;

@end
