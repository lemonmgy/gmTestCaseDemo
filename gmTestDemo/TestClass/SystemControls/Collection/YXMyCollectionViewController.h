//
//  YXMyCollectionViewController.h
//  test
//
//  Created by lemonmgy on 2016/12/7.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r, g, b)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBSimeValue(rgb)   [UIColor colorWithRed:rgb/255.0 green:rgb/255.0 blue:rgb/255.0 alpha:1.0]
#define rgba(r, g, b, a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define YXScreenW [UIScreen mainScreen].bounds.size.width
#define YXScreenH [UIScreen mainScreen].bounds.size.height
@interface YXMyCollectionViewController : UIViewController

@end
