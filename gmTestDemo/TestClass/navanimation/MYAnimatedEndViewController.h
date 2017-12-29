//
//  MYAnimatedEndViewController.h
//  test
//
//  Created by lemonmgy on 2017/1/19.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYAnimatedEndViewController : UIViewController
@property (nonatomic ,copy)   NSString *imageName;
@property (nonatomic ,assign) CGRect startFrame;
@property (nonatomic ,strong) UIButton *imageView;
@property (nonatomic, strong) UIView *bcakView;
@property (nonatomic ,assign) BOOL show;
@end
