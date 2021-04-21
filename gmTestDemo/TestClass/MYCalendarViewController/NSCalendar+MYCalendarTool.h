//
//  Created by lemonmgy on 2017/4/6.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYCalendarDayItem : NSObject<NSCopying,NSMutableCopying>
@property (nonatomic, strong) NSDateComponents *component;
@property (nonatomic, assign) BOOL hidden;
@end

@interface MYCalendarMonthItem : NSObject

@property (nonatomic, strong) NSMutableArray <MYCalendarDayItem *>*dayItemArray;
@property (nonatomic, assign) NSInteger allDays;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger year;

@end

@interface NSCalendar (MYCalendarTool)
@property (nonatomic, strong) NSDate *currentDay;
- (NSDate *)newDate:(NSDateComponents *)com;
- (NSMutableArray *)calendarMonthArrayDataWithNumber:(int)number andBaseDate:(NSDate *)date;
- (NSMutableArray *)calendarOnlyMonthArrayDataWithNumber:(int)number andBaseDate:(NSDate *)date;
- (NSMutableArray *)calendarOnlyDayArrayDataWithNumber:(int)number andBaseDate:(NSDate *)date;

/**
 *      获取某个时间 之后的几个月时间
 *      startDate 起始时间
 *      count     之后几个月的月数
 *      handler   date时间结果  allDayCount 相差天数
 *
 *      例如 ： startDate = 2017-05-01 count = 3 date=@[2017-05-01,2017-05-02,2017-05-03,2017-05-04] allDayCount = 总天数
 */
- (void)endDateWithStartDate:(id)startDate monthCount:(int)count handler:(void (^)(NSArray <NSString*>*date, NSInteger allDayCount))handler;
/**
 *      一天之后 多少天
 *      使用场景:
 *      1、accurate 为yes 精确   endDate与startDate 差值为count
 *      2、accurate 为no  不精确 endDate与startDate 差值>=count
 */
- (void)oneDayAfterNumberOfDaysWithStartDate:(id)startDate dayCount:(int)count accurate:(BOOL)accurate handler:(void (^)(NSArray <NSString*>*date, NSInteger allDayCount))handler;
/**
 *      格式化
 *      使用场景:
 *      参数 year month day
 *      返回 2017-01-01
 */
+ (NSString *)completeDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
@end
