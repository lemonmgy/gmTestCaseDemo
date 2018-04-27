//
//  GMAlert.h
//  gmTestDemo
//
//  Created by lemonmgy on 2018/4/26.
//  Copyright © 2018年 lemonmgy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMAlert : NSObject


#define kShowAlert(msg)     [BaseViewController show:msg andForever:NO]
#define kShowForever(msg)   [BaseViewController show:msg andForever:YES]
#define kHiddenForever(msg) [BaseViewController hidden:msg]
@end
