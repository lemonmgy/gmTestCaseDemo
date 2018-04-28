//
//  BaseViewController.h
//  test
//
//  Created by lemonmgy on 16/10/27.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController

@property (nonatomic, strong) NSMutableArray <NSString *>*bottombtnNameArr;
@property (nonatomic, strong) NSArray <NSString *>*topItemNameArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableViewDataArr;
@property (nonatomic, strong) NSMutableArray *iconNameArr;
@property (nonatomic, strong) UIColor *cellColor;

- (void)bottomButtonClick:(UIButton *)sender;
- (void)topButtonClick:(UIBarButtonItem *)sender;

@property (nonatomic, strong) NSMutableArray *testArray;

@end
