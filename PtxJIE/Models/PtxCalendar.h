//
//  PtxCalendar.h
//  PtxJIE
//
//  Created by chenfeng on 15/8/19.
//  Copyright (c) 2015年 fido0725. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TabooNormal.h"

@interface PtxCalendar : NSObject

@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger month;
@property (nonatomic) NSInteger day;
@property (nonatomic) NSInteger weekday;//1星期日 7星期六
@property (nonatomic) NSInteger weekOfMonth;
///农历
@property (nonatomic,strong) NSString *cn_year;
@property (nonatomic,strong) NSString *cn_month;
@property (nonatomic,strong) NSString *cn_day;
///中国节日
@property (nonatomic,strong) NSString *cn_holiday;
///二十四节气
@property (nonatomic,strong) NSString *cn_solar;

@property (nonatomic,strong) TabooNormal *tabooNormal;

///与今天差距 正数为后天，负数为前天，0为当天
@property (nonatomic) NSInteger detalDays;

-(id)initWithDate:(NSDate *)date;
+(instancetype)current;
-(void)dayBeforeCurrentWithDays:(NSInteger)days orNot:(BOOL)enable;
-(NSArray *)currentMonth;
-(NSArray *)allMonth;
@end
