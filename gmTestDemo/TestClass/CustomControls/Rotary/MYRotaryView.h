//
//  myview.h
//  testlayer
//
//  Created by lemonmgy on 2017/1/16.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYRotaryView : UIView

@property (nonatomic, copy) void(^block)(NSString *title);
@end
