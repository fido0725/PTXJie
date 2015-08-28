//
//  NSDateComponents+PtxLunar.m
//  PtxJIE
//
//  Created by ptx on 15/8/26.
//  Copyright (c) 2015年 fido0725. All rights reserved.
//

#import "NSDateComponents+PtxLunar.h"

@implementation NSDateComponents (PtxLunar)



-(NSDictionary *)lunar
{
    NSArray *_tianGan = @[@"",@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸"];
    
    NSArray *_diZhi = @[@"",@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥"];
    NSArray *_yueFen = @[@"",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊"];
    NSArray *_riZi = @[@"",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                       @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                       @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十"];
    
    NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
    NSInteger year = self.year;
    NSString *lyear = [_tianGan[year%10] stringByAppendingString:_diZhi[year%12]];
    [mdict setValue:lyear forKey:LunarYear];
    
    NSInteger month = self.month;
    NSString *lmonth = _yueFen[month];
    [mdict setValue:lmonth forKey:LunarMonth];
    
    NSInteger day = self.day;
    NSString *lday;
    if (day==1) {
        lday = [lmonth stringByAppendingString:@"月"];
    }
    else
    {
        lday = _riZi[day];
    }
    [mdict setValue:lday forKey:LunarDay];
    
    return (NSDictionary *)mdict;
}


@end
