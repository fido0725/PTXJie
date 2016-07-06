//
//  TabooComparator.m
//  PtxJIE
//
//  Created by chenfeng on 16/7/6.
//  Copyright © 2016年 fido0725. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TabooComparator.h"

@interface TabooComparatorTest : XCTestCase
@property (nonatomic,strong) TabooComparator *comparator;
@end

@implementation TabooComparatorTest

- (void)setUp {
    [super setUp];
    if (self.comparator == nil ) {
        self.comparator = [[TabooComparator alloc]init];
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

-(void)testTimeSpecialSolar
{
    NSString *str = [self.comparator timeAttentionSolar:@"春分"];
    NSAssert(str, @"时节数据库为空");
    NSLog(@"str is %@",str);
}

-(void)testSeasonPeriod
{
    NSArray *arr0 = [self.comparator vernalEquinoxPeriod];
    NSAssert(arr0.count>0, @"春分时期没有数据返回");
    NSLog(@"春分忌期 is %@",arr0);
    NSArray *arr1 = [self.comparator autumalEquinoxPeriod];
    NSAssert(arr1.count>0, @"秋分时期没有数据返回");
    NSLog(@"秋分忌期 is %@",arr1);
    
    NSArray *arr2 = [self.comparator summerSolsticePeriod];
    NSAssert(arr2.count>0, @"夏至时期没有数据返回");
    NSLog(@"夏至忌期 is %@",arr2);
    
    NSArray *arr3 = [self.comparator winterSolsticePeriod];
    NSAssert(arr3.count>0, @"冬至时期没有数据返回");
    NSLog(@"冬至忌期 is %@",arr3);
}

-(void)testSeasonDay
{
    NSArray *arr0 = [self.comparator specialDayInSeason];
    NSAssert(arr0.count>0, @"四立日无数据");
    NSLog(@"四立日时间：%@",arr0);
    
    NSArray *arr1 = [self.comparator specialDayBeforeSeason];
    NSAssert(arr1.count>0, @"四绝日无数据");
    NSLog(@"四绝日时间：%@",arr1);
}
@end
