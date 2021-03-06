//
//  TabooComparator.h
//  PtxJIE
//
//  Created by ptx on 16/7/6.
//  Copyright © 2016年 fido0725. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TabooComparator : NSObject

-(NSString *)timeAttentionSolar:(NSString *)solarName;

-(NSArray *)vernalEquinoxPeriod;

-(NSArray *)autumalEquinoxPeriod;

-(NSArray *)summerSolsticePeriod;

-(NSArray *)winterSolsticePeriod;

-(NSArray *)specialDayInSeason;

-(NSArray *)specialDayBeforeSeason;
@end
