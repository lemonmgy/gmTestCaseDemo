//
//  Created by lemonmgy on 2017/4/6.
//  Copyright © 2017年 lemonmgy. All rights reserved.
//

#import "NSCalendar+MYCalendarTool.h"
#import <objc/runtime.h>

typedef void(^MonthInfoBlock)(NSInteger allDays, NSDateComponents *component);

@implementation MYCalendarDayItem
- (id)copyWithZone:(NSZone *)zone {
    return [self mutableCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    MYCalendarDayItem *item = [MYCalendarDayItem new];
    item.component = [self.component copy];
    item.hidden = self.hidden;
    return item;
}
@end

@implementation MYCalendarMonthItem
- (NSMutableArray<MYCalendarDayItem *> *)dayItemArray {
    if (!_dayItemArray) {
        _dayItemArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _dayItemArray;
}
@end


@implementation NSCalendar (MYCalendarTool)

- (void)setCurrentDay:(NSDate *)currentDay {
    if (!currentDay) currentDay = [NSDate date];
    objc_setAssociatedObject(self, @selector(currentDay), currentDay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)currentDay {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSDateComponents *)currentDayComponent {
    NSDateComponents *component = objc_getAssociatedObject(self, _cmd);
    if (!component) {
        component = [self components:[self myUnitFlags] fromDate:[self currentDay]];
        objc_setAssociatedObject(self, _cmd, component, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    return component;
}

- (void)numberOfDaysWithCurrentMonthAfterMonth:(int)month andBlock:(MonthInfoBlock)infoBlock {
    NSDateComponents *baseDayComponent = [[self currentDayComponent] copy];
    NSInteger tempMonth = baseDayComponent.month + month;
    NSInteger currentMonth = tempMonth%12;
    baseDayComponent.day = 1;
    if (month < 0) {
        if (tempMonth <= 0) currentMonth = 12 + tempMonth%12;
        baseDayComponent.month = currentMonth;
        if (tempMonth <= 0) baseDayComponent.year -= 1;
        baseDayComponent.year += tempMonth/12;
    }else {
        if (currentMonth%12 == 0) {
            currentMonth = 12;
            baseDayComponent.year += tempMonth/12 - 1;
        }else {
            baseDayComponent.year += tempMonth/12;
        }
        baseDayComponent.month = currentMonth;
    }
    
    baseDayComponent = [self newComponents:baseDayComponent];
    NSUInteger allDays = [self allDaysNumber:baseDayComponent];
    if (baseDayComponent.weekday<1 || baseDayComponent.weekday>7) {
        [self weekday:baseDayComponent];
    }
    
    if (infoBlock) {
        infoBlock(allDays, baseDayComponent);
    }
}

- (NSDate *)newDate:(NSDateComponents *)com {
    
    NSString *dateString = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld",(long)com.year,(long)com.month,(long)com.day,(long)com.hour,(long)com.minute,(long)com.second];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *newDate = [fmt dateFromString:dateString];
    return newDate;
}

- (NSDateComponents *)newComponents:(NSDateComponents *)com {
    return [self components:[self myUnitFlags] fromDate:[self newDate:com]];
}

- (NSCalendarUnit)myUnitFlags {
    return NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday;
}

- (NSUInteger)allDaysNumber:(NSDateComponents *)components {
    return [self allDaysOrWeekday:NO components:components];
}
- (NSUInteger)weekday:(NSDateComponents *)components {
    return [self allDaysOrWeekday:YES components:components];
}
- (NSUInteger)allDaysOrWeekday:(BOOL)weekday components:(NSDateComponents *)components {
    NSDate *newDate = [self dateFromComponents:components];
    if (weekday) {
        return [self ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:newDate];
    }else {
        return [self rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:newDate].length;
    }
}

- (void)oneDayAfterNumberOfDaysWithStartDate:(id)startDate dayCount:(int)count accurate:(BOOL)accurate handler:(void (^)(NSArray <NSString*>*date, NSInteger allDayCount))handler {
    
    NSDate *baseDate = startDate;
    if ([startDate isKindOfClass:[NSString class]]) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        baseDate = [fmt dateFromString:startDate];
    }else if ([startDate isKindOfClass:[NSDate class]]) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        startDate = [fmt stringFromDate:startDate];
    }
    
    NSArray *tempArray = [self calendarOnlyDayArrayDataWithNumber:(count/30+1) andBaseDate:baseDate];
    if (!tempArray.count){
        handler? handler(@[],0):nil;
        return;
    }
    
    NSString *tempDay = [[startDate componentsSeparatedByString:@"-"] lastObject];
    
    NSMutableArray *dateArray = [NSMutableArray arrayWithCapacity:10];
    BOOL add = NO;
    int index = 0;
    for (MYCalendarDayItem *dayItem in tempArray) {
        tempDay = [[self class] completeDateWithYear:dayItem.component.year month:dayItem.component.month day:dayItem.component.day];
        
        if ([tempDay isEqualToString:startDate]) {
            add = YES;
        }
        if(add) {
            [dateArray addObject:tempDay];
            if (accurate) {
                if (index == count) break;
                index ++;
            }
        }
        
    }
    if (handler) handler(dateArray,count);
}

- (void)endDateWithStartDate:(id)startDate monthCount:(int)count handler:(void (^)(NSArray <NSString*>*date, NSInteger allDayCount))handler {
    NSDate *baseDate = startDate;
    if ([startDate isKindOfClass:[NSString class]]) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        baseDate = [fmt dateFromString:startDate];
    }else if ([startDate isKindOfClass:[NSDate class]]) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        startDate = [fmt stringFromDate:startDate];
    }
    
    NSArray *tempArray = [self calendarOnlyMonthArrayDataWithNumber:count andBaseDate:baseDate];
    if (!tempArray.count){
        handler? handler(@[],0):nil;
        return;
    }
    
    NSString *day = [[startDate componentsSeparatedByString:@"-"] lastObject];
    
    //本月最后一天最后一天
    MYCalendarMonthItem *firstMonthItem = tempArray[0];
    BOOL lastDay = (firstMonthItem.allDays == [day integerValue]);
    NSInteger all_day_count = 0;
    NSMutableArray *dateArray = [NSMutableArray arrayWithCapacity:10];
    for (MYCalendarMonthItem *monthItem in tempArray) {
        all_day_count += monthItem.allDays;
        [dateArray addObject:[[self class] completeDateWithYear:monthItem.year month:monthItem.month day:(lastDay? monthItem.allDays:[day integerValue])]];
    }
    MYCalendarMonthItem *lastMonthItem = [tempArray lastObject];
    all_day_count -= lastMonthItem.allDays;
    all_day_count += (lastDay? lastMonthItem.allDays:[day integerValue]);
    all_day_count -= firstMonthItem.allDays;
    all_day_count += firstMonthItem.allDays - [day integerValue];
    if (handler) handler(dateArray,all_day_count);
}

+ (NSString *)completeDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    return [NSString stringWithFormat:@"%04ld-%02ld-%02ld",(long)year,(long)month,(long)day];
}

- (NSMutableArray *)calendarMonthArrayDataWithNumber:(int)number andBaseDate:(NSDate *)date{
    return [self calendarMonthArrayDataWithNumber:number andBaseDate:date onlyMonth:NO onlyDay:NO];
}

- (NSMutableArray *)calendarOnlyMonthArrayDataWithNumber:(int)number andBaseDate:(NSDate *)date {
    return [self calendarMonthArrayDataWithNumber:number andBaseDate:date onlyMonth:YES onlyDay:NO];
}

- (NSMutableArray *)calendarOnlyDayArrayDataWithNumber:(int)number andBaseDate:(NSDate *)date {
    return [self calendarMonthArrayDataWithNumber:number andBaseDate:date onlyMonth:NO onlyDay:YES];
}

- (NSMutableArray *)calendarMonthArrayDataWithNumber:(int)number andBaseDate:(NSDate *)date onlyMonth:(BOOL)onlyMonth onlyDay:(BOOL)onlyDay {
    
    self.currentDay = date;
    
    NSMutableArray *allDayArray = [NSMutableArray new];
    NSMutableArray *monthArray = [NSMutableArray new];
    
    int allMonth = number >= 0 ? number+1:-number+1;
    int month = 0;
    
    @autoreleasepool {
        for (int j = 0; j < allMonth; j++) {
            month = number > 0 ? j : -j;
            [self numberOfDaysWithCurrentMonthAfterMonth:month andBlock:^(NSInteger allDays, NSDateComponents *component) {
                MYCalendarMonthItem *monthItem = [MYCalendarMonthItem new];
                monthItem.month = component.month;
                monthItem.year = component.year;
                monthItem.allDays = allDays;
                
                if (!onlyMonth) {
                    for (NSUInteger i = 0; i < allDays; i++) {
                        MYCalendarDayItem *item = [MYCalendarDayItem new];
                        item.component = [component copy];
                        item.component.day = i+1;
                        item.component.weekday = [self weekday:item.component];
                        if (i == 0) {
                            for (NSUInteger i = 0; i < item.component.weekday-1; i++) {
                                [monthItem.dayItemArray addObject:[MYCalendarDayItem new]];
                            }
                        }
                        [monthItem.dayItemArray addObject:item];
                    }
                }
                
                if (number>=0) {
                    [monthArray addObject:monthItem];
                }else {
                    [monthArray insertObject:monthItem atIndex:0];
                }
                
                if (onlyDay) [allDayArray addObjectsFromArray:monthItem.dayItemArray];
            }];
        }
    }
    
    if (onlyDay) {
        return allDayArray;
    }else {
        return monthArray;
    }
}

@end
