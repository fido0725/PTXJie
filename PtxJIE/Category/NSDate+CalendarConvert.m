//
//  NSDate+CalendarConvert.m
//  PtxJIE
//
//  Created by chenfeng on 15/8/26.
//  Copyright (c) 2015年 fido0725. All rights reserved.
//

#import "NSDate+CalendarConvert.h"

@implementation NSDate (CalendarConvert)

+(id)shareCalendarGeo
{
    static NSCalendar *geoCalendar = nil;
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        geoCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [geoCalendar setFirstWeekday:1];
    });
    return geoCalendar;
}

-(NSDateComponents *)YMDcomponent
{
    NSCalendar *calendar = [NSDate shareCalendarGeo];
    NSCalendarUnit flag = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekdayOrdinal;
    NSDateComponents *component = [calendar components:flag fromDate:self];
    return component;
}

-(NSDateComponents *)YMDLunarComponent
{
    NSCalendar *calendarCn = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSCalendarUnit flag = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *componentCn = [calendarCn components:flag fromDate:self];
    return componentCn;
}

///设置周首日次序号
-(NSInteger)setFirstWeekDayWithIt:(NSInteger)weekday
{
    if (!weekday) {
        return FALSE;
    }
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:weekday]; // Sunday == 1, Saturday == 7
    NSUInteger adjustedWeekdayOrdinal = [gregorian ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
    return adjustedWeekdayOrdinal;
}


-(NSInteger)monthAfterNumber:(NSInteger)num
{
    NSDateComponents *currentComp = [self YMDcomponent];
    return currentComp.month + num;
}

-(NSInteger)monthBeforeNumber:(NSInteger)num
{
   return [self monthAfterNumber:-num];
}

-(NSInteger)allDaysThisMonth
{
    NSCalendar *calendar = [NSDate shareCalendarGeo];
  NSRange rang = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return rang.length;
}

-(NSDate *)firstDayThisMonth
{
    NSCalendar *calendar = [NSDate shareCalendarGeo];
    NSDate *firstDay;
   BOOL isOk = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDay interval:nil forDate:self];
    if (isOk) {
        return firstDay;
    }
    return nil;
}

-(NSInteger)allWeeksThisMonth
{
    NSCalendar *calendar = [NSDate shareCalendarGeo];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

-(NSDate *)specialDayBetweenTodayWithNum:(NSInteger)day
{
    NSCalendar *calendar = [NSDate shareCalendarGeo];
    NSDateComponents *component = [[NSDateComponents alloc] init];
    component.day = day;
    return [calendar dateByAddingComponents:component toDate:self options:0];
}

-(NSDate *)specialDayBeforeTodayWithNum:(NSInteger)day
{
   return [self specialDayBetweenTodayWithNum:-day];
}

-(NSDate *)specialDayAfterTodayWithNum:(NSInteger)day
{
    return [self specialDayBetweenTodayWithNum:day];
}

-(NSDateComponents *)daysCompareWithDate:(NSDate*)endDate
{
    NSCalendar *calendar = [NSDate shareCalendarGeo];
    //NSInteger flag = NSCalendarUnitDay|NSCalendarUnitMonth;
    NSDateComponents *comp = [ calendar components:NSCalendarUnitDay fromDate:self toDate:endDate options:0];
    return comp;
}
@end
