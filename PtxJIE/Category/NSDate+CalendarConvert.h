//
//  NSDate+CalendarConvert.h
//  PtxJIE
//
//  Created by chenfeng on 15/8/26.
//  Copyright (c) 2015年 fido0725. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CalendarConvert)

-(NSDateComponents *)YMDcomponent;

-(NSDateComponents *)YMDLunarComponent;

+(id)shareCalendarGeo;

-(NSInteger)setFirstWeekDayWithIt:(NSInteger)weekday;

-(NSInteger)monthAfterNumber:(NSInteger)num;

-(NSInteger)monthBeforeNumber:(NSInteger)num;

-(NSInteger)allDaysThisMonth;

-(NSDate *)firstDayThisMonth;

-(NSInteger)allWeeksThisMonth;

-(NSDate *)specialDayBeforeTodayWithNum:(NSInteger)day;

-(NSDate *)specialDayAfterTodayWithNum:(NSInteger)day;

-(NSDateComponents *)daysCompareWithDate:(NSDate*)endDate;

@end
