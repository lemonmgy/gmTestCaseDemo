//
//  MYMediaTools.h
//  gmTestDemo
//
//  Created by lemonmgy on 2017/3/3.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYMediaTools : NSObject

+ (BOOL)judgeIsHavePhotoAblumAuthority;//是否有相册权限
+ (BOOL)judgeIsHaveCameraAuthority; //是否有相机权限
+ (void)openTheApplicationSettings; //打开应用设置
@end
