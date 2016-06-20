//
//  PtxCalendar.m
//  PtxJIE
//
//  Created by chenfeng on 15/8/19.
//  Copyright (c) 2015年 fido0725. All rights reserved.
//

#import "PtxCalendar.h"
#import "NSDate+CalendarConvert.h"
#import "NSDateComponents+PtxLunar.h"
#import "Store.h"
#import "TabooNormal.h"

@interface PtxCalendar()
@property (nonatomic,strong)  NSDate *currentDate;
@property (nonatomic,strong) Store *store;
@property (nonatomic,strong) NSManagedObjectContext *privateContext;
@end

@implementation PtxCalendar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.store = [[Store alloc]init];
        self.privateContext = self.store.newPrivateContext;
        [self calendarWithDate:nil];
    }
    return self;
}

-(id)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        [self calendarWithDate:date];
    }
    return self;
}

-(NSDate *)currentDate
{
    if (!_currentDate) {
        _currentDate = [NSDate date];
    }
    return _currentDate;
}

+(instancetype)current
{
    PtxCalendar *instance = [[self alloc] init];
    return instance;
}

-(void)calendarWithDate:(NSDate *)preDate
{
    NSDate *tempDate;
    if (preDate) {
        tempDate = preDate;
        self.currentDate = preDate;
    }
    else
    {
        tempDate = self.currentDate;
    }
    NSDateComponents *comp = [tempDate YMDcomponent];
    NSDateComponents *lunarcomp = [tempDate YMDLunarComponent];
    NSDictionary *lunarDict = [lunarcomp lunar];
    self.year = comp.year;
    self.month = comp.month;
    self.day = comp.day;
    self.weekday = comp.weekday;
    self.weekOfMonth = comp.weekOfMonth;
    
    self.cn_year = lunarDict[LunarYear];
    self.cn_month = lunarDict[LunarMonth];
    self.cn_day = lunarDict[LunarDay];
    

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"month == %@ AND day == %@", [NSString stringWithFormat:@"%@月",self.cn_month],self.cn_day];
    [fetchRequest setPredicate:predicate];
    NSEntityDescription *entity;
    NSArray *fetchedObjects;
    NSError *error = nil;
    if ([NSThread currentThread] != [NSThread mainThread]) {
        entity = [NSEntityDescription entityForName:@"TabooNormal" inManagedObjectContext:self.privateContext];
        [fetchRequest setEntity:entity];

        fetchedObjects = [self.privateContext executeFetchRequest:fetchRequest error:&error];

    }
    else
    {
        entity = [NSEntityDescription entityForName:@"TabooNormal" inManagedObjectContext:self.store.mainManagedObjectContext];
        [fetchRequest setEntity:entity];

        fetchedObjects = [self.store.mainManagedObjectContext executeFetchRequest:fetchRequest error:&error];
        
    }
    if (fetchedObjects == nil || fetchedObjects.count == 0) {
        self.tabooNormal = nil;
    }
    else
    {
       self.tabooNormal = fetchedObjects[0];
    }
    //self.detalDays = [_currentDate daysCompareWithDate:tempDate].day;
}



-(void)dayBeforeCurrentWithDays:(NSInteger)days orNot:(BOOL)enable
{

    NSDate *specialDay;
    
    if (enable) {
        specialDay = [self.currentDate specialDayBeforeTodayWithNum:days];
    }
    else
    {
        specialDay = [self.currentDate specialDayAfterTodayWithNum:days];
    }
    [self calendarWithDate:specialDay];

}

-(NSArray *)currentMonth
{
    return [self daysInMonthWithDate:self.currentDate];
}

-(NSArray *)daysInMonthWithDate:(NSDate *)date
{
    NSInteger days = [date allDaysThisMonth];
    NSDate *firstDate = [date firstDayThisMonth];
    NSMutableArray *marray = [NSMutableArray array];
    for (int i=0; i<days; i++) {
        PtxCalendar *model = [[PtxCalendar alloc] init];
        NSDate *special = [firstDate specialDayAfterTodayWithNum:i];
        [model calendarWithDate:special];
        if (model) {
            [marray addObject:model];
        }
    }
    return (NSArray *)marray;
}

-(NSArray *)allMonth
{
    NSDateComponents *comp = [self.currentDate YMDcomponent];
    NSCalendar *calendar = [NSDate shareCalendarGeo];
    NSMutableArray *allMonths = [NSMutableArray array];
    for (int i=1; i<=12; i++) {
        PtxCalendar *model = [[PtxCalendar alloc] init];
        NSDateComponents *tempComp = [[NSDateComponents alloc] init];
        tempComp.year = comp.year;
        tempComp.month = i;
        tempComp.day = 1;
        NSDate *theDate = [calendar dateFromComponents:tempComp];
        [allMonths addObject: [model daysInMonthWithDate:theDate]];
    }
    return (NSArray *)allMonths;
}
@end
