//
//  PtxCalendarTests.m
//  PtxJIE
//
//  Created by chenfeng on 15/8/21.
//  Copyright (c) 2015年 fido0725. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PtxCalendar.h"
#import "NSDate+CalendarConvert.h"
#import "NSDateComponents+PtxLunar.h"

@interface PtxCalendarTests : XCTestCase
{
    @private
    NSDate *_shareDate;
}
@end

@implementation PtxCalendarTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _shareDate = [self fixDate];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

-(void)testThatCurrentMonth
{
    NSDateComponents *component = [_shareDate YMDcomponent];
    XCTAssertTrue(component.month == 8);
}

-(void)testThatCurrentYMD
{
    NSDateComponents *component = [_shareDate YMDcomponent];

    XCTAssertEqualObjects(@2015, @(component.year));
    XCTAssertTrue(8==component.month);
    XCTAssertTrue(26==component.day);
}

-(void)testTahtCurrentYMDcn
{
    NSDateComponents *componentCn = [_shareDate YMDLunarComponent];
    XCTAssertTrue(componentCn.year%10==2 && componentCn.year%12==8); //乙未年
    XCTAssertTrue(componentCn.month == 7);
    XCTAssertTrue(componentCn.day == 13);
}

-(NSDate *)fixDate
{
    NSCalendar *calendar = [NSDate  shareCalendarGeo];
    NSCalendarUnit flag = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *component = [[NSDateComponents alloc] init];
    component.year = 2015;
    component.month = 8;
    component.day = 26;
    NSDate *fixdate = [calendar dateFromComponents:component];
    return fixdate;
}

-(void)testThatSetFirstWeedDayMonday
{
    NSInteger firstweekday = [_shareDate setFirstWeekDayWithIt:2];
    XCTAssertTrue(firstweekday==3,@"weekday is %d",firstweekday);
}

-(void)Disable_testThatThisMonthAllDays
{

}

-(void)testThatBeforeMonth
{
   NSInteger month = [_shareDate monthBeforeNumber:1];
    XCTAssertTrue(month==7);
}

-(void)testThatAfterMonth
{
    NSInteger month = [_shareDate monthAfterNumber:1];
    XCTAssertTrue(month==9);
}

-(void)testThisMonthAllDays
{
    NSInteger days = [_shareDate allDaysThisMonth];
    XCTAssertTrue(days==31);
}

-(void)testThatFirstDayThisMonth
{
   NSDate *firstDay = [_shareDate firstDayThisMonth];
    NSDateComponents *firstComp = [firstDay YMDcomponent];
    XCTAssertTrue(firstComp.year == 2015);
    XCTAssertTrue(firstComp.month == 8);
    XCTAssertTrue(firstComp.day == 1);
    XCTAssertTrue(firstComp.weekday == 7);
    XCTAssertTrue(firstComp.weekOfMonth == 1);
}

-(void)testAllWeeksThisMonth
{
    NSInteger weeks = [_shareDate allWeeksThisMonth];
    XCTAssertTrue(weeks == 6);
}

-(void)testPreferTimeAfterNumDays
{
    NSDate *date = [_shareDate specialDayAfterTodayWithNum:2];
   NSDateComponents *component = [date YMDcomponent];
    XCTAssertTrue(component.year == 2015);
    XCTAssertTrue(component.month == 8);
    XCTAssertTrue(component.day == 28);
    XCTAssertTrue(component.weekday == 6);
    XCTAssertTrue(component.weekOfMonth == 5);
}

-(void)testPreferTimeBeforNumDays
{
    NSDate *date = [_shareDate specialDayBeforeTodayWithNum:2];
    NSDateComponents *component = [date YMDcomponent];
    XCTAssertTrue(component.year == 2015);
    XCTAssertTrue(component.month == 8);
    XCTAssertTrue(component.day == 24);
    XCTAssertTrue(component.weekday == 2);
    XCTAssertTrue(component.weekOfMonth == 5);
}

-(void)testLunarDay
{
    NSDateComponents *lunarComp = [_shareDate YMDLunarComponent];
    NSDictionary *dict = [lunarComp lunar];
    XCTAssertNotNil(dict,"lunar is %@年 %@月 %@",dict[LunarYear],dict[LunarMonth],dict[LunarDay]);
}
@end
