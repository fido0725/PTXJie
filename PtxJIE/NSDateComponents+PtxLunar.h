//
//  NSDateComponents+PtxLunar.h
//  PtxJIE
//
//  Created by ptx on 15/8/26.
//  Copyright (c) 2015年 fido0725. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const LunarYear = @"year_lunar";
static NSString *const LunarMonth = @"month_lunar";
static NSString *const LunarDay = @"day_lunar";
static NSString *const LunarHoliday = @"holiday_lunar";
static NSString *const LunarSolar = @"solar_lunar";

@interface NSDateComponents (PtxLunar)

-(NSDictionary *)lunar;

@end
