//
//  MYCalendarSwitchView.h
//  gmTestDemo
//
//  Created by lemonmgy on 2017/8/8.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYCalendarMonthItem;
@class MYCalendarDayItem;

typedef void(^MYCalendarSwitchBlock)(MYCalendarMonthItem *monthItem);
typedef void(^MYCalendarClickBlock)(MYCalendarDayItem *dayItem);

@interface MYCalendarSwitchView : UIView
@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, copy) MYCalendarSwitchBlock switchSuccessBlock;//切换成功
@property (nonatomic, copy) MYCalendarClickBlock clickItemBlock;//点击了item
@property (nonatomic, copy) void(^updateLayout)();

- (void)updateDatas;//刷新数据
@end


