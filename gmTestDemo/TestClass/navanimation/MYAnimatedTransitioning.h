//
//  MYTransionPush.h
//  test
//
//  Created by lemonmgy on 2017/1/5.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationControllerOperation operation;

@end
