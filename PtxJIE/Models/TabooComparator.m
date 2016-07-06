//
//  TabooComparator.m
//  PtxJIE
//
//  Created by ptx on 16/7/6.
//  Copyright © 2016年 fido0725. All rights reserved.
//

#import "TabooComparator.h"
#import "LunarCalendar.h"
#import "Store.h"
#import "TabooSolar.h"

NSString *const kTabooName = @"tabooName";
NSString *const kTabooStart = @"tabooStart";
NSString *const kDuration = @"duration";
NSString *const kDescript = @"descript";
NSString *const kComeout = @"comeout";
NSString *const kIsMust = @"isMust";
@interface TabooComparator()

@property (nonatomic,strong) Store *store;
@property (nonatomic,strong) LunarCalendar *lunarCalendar;
@property (nonatomic,strong) NSManagedObjectContext *managedContext;
@end

@implementation TabooComparator
{
    NSManagedObjectContext *_privateContext;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        _store = [[Store alloc]init];
        _lunarCalendar = [[LunarCalendar alloc]init];
        _privateContext = _store.newPrivateContext;
    }
    return self;
}

-(NSManagedObjectContext *)managedContext
{
    return [NSThread isMainThread]?self.store.mainManagedObjectContext:_privateContext;
}

-(NSString *)timeAttentionSolar:(NSString *)solarName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TabooSolar" inManagedObjectContext:self.managedContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"solarName == %@", solarName];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count) {
        TabooSolar *solar = [fetchedObjects firstObject];
        return solar.solarDate;
    }
    return nil;
}

#pragma mark - 二分二至之月

-(NSArray *)vernalEquinoxPeriod
{
    NSMutableArray *marr = [NSMutableArray array];
    NSString *des = @"春分时期，雷将发声";
    NSString *res = @"生子五官四肢不全、父母有灾";
    {
    NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
    NSString *time = [self timeAttentionSolar:@"春分"];
    [mdict setObject:time forKey:kTabooStart];
    [mdict setObject:@3 forKey:kDuration];
    [mdict setObject:des forKey:kDescript];
    [mdict setObject:res forKey:kComeout];
    [mdict setObject:@(YES) forKey:kIsMust];
    [marr addObject:[mdict copy]];
    }
    {
        NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
        NSString *time = [self timeAttentionSolar:@"惊蛰"];
        [mdict setObject:time forKey:kTabooStart];
        [mdict setObject:@30 forKey:kDuration];
        [mdict setObject:des forKey:kDescript];
        [mdict setObject:res forKey:kComeout];
        [mdict setObject:@(NO) forKey:kIsMust];
        [marr addObject:[mdict copy]];
    }
    return [marr copy];
}


-(NSArray *)autumalEquinoxPeriod
{
    NSMutableArray *marr = [NSMutableArray array];
    NSString *des = @"秋分时期";
    NSString *res = @"杀气浸盛，阳气日衰";
    {
        NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
        NSString *time = [self timeAttentionSolar:@"秋分"];
        [mdict setObject:time forKey:kTabooStart];
        [mdict setObject:@3 forKey:kDuration];
        [mdict setObject:des forKey:kDescript];
        [mdict setObject:res forKey:kComeout];
        [mdict setObject:@(YES) forKey:kIsMust];
        [marr addObject:[mdict copy]];
    }
    {
        NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
        NSString *time = [self timeAttentionSolar:@"白露"];
        [mdict setObject:time forKey:kTabooStart];
        [mdict setObject:@30 forKey:kDuration];
        [mdict setObject:des forKey:kDescript];
        [mdict setObject:res forKey:kComeout];
        [mdict setObject:@(NO) forKey:kIsMust];
        [marr addObject:[mdict copy]];
    }
    return [marr copy];
}

-(NSArray *)summerSolsticePeriod
{
    NSMutableArray *marr = [NSMutableArray array];
    NSString *des = @"夏至时期，阴阳相争，死生分判之时";
    NSString *res = @"犯之必得急疾";
    {
        NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
        NSString *time = [self timeAttentionSolar:@"夏至"];
        [mdict setObject:time forKey:kTabooStart];
        [mdict setObject:@3 forKey:kDuration];
        [mdict setObject:des forKey:kDescript];
        [mdict setObject:res forKey:kComeout];
        [mdict setObject:@(YES) forKey:kIsMust];
        [marr addObject:[mdict copy]];
    }
    {
        NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
        NSString *time = [self timeAttentionSolar:@"芒种"];
        [mdict setObject:time forKey:kTabooStart];
        [mdict setObject:@30 forKey:kDuration];
        [mdict setObject:des forKey:kDescript];
        [mdict setObject:res forKey:kComeout];
        [mdict setObject:@(NO) forKey:kIsMust];
        [marr addObject:[mdict copy]];
    }
    return [marr copy];
}

-(NSArray *)winterSolsticePeriod
{
    NSMutableArray *marr = [NSMutableArray array];
    NSString *des = @"冬至时期，阴阳相争，死生分判之时";
    NSString *res = @"犯之必得急疾";
    {
        NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
        NSString *time = [self timeAttentionSolar:@"冬至"];
        [mdict setObject:time forKey:kTabooStart];
        [mdict setObject:@3 forKey:kDuration];
        [mdict setObject:des forKey:kDescript];
        [mdict setObject:res forKey:kComeout];
        [mdict setObject:@(YES) forKey:kIsMust];
        [marr addObject:[mdict copy]];
    }
    {
        NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
        NSString *time = [self timeAttentionSolar:@"大雪"];
        [mdict setObject:time forKey:kTabooStart];
        [mdict setObject:@30 forKey:kDuration];
        [mdict setObject:des forKey:kDescript];
        [mdict setObject:res forKey:kComeout];
        [mdict setObject:@(NO) forKey:kIsMust];
        [marr addObject:[mdict copy]];
    }
    return [marr copy];
}

-(NSArray *)specialDayInSeason
{
    
    NSMutableArray *marr = [NSMutableArray array];
    NSString *des = @"四立日";
    NSString *res = @"减寿五年";
    NSArray *season = @[@"立春",@"立夏",@"立秋",@"立冬"];
    for (NSString *s in season)
    {
        NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
        NSString *time = [self timeAttentionSolar:s];
        [mdict setObject:time forKey:kTabooStart];
        [mdict setObject:@0 forKey:kDuration];
        [mdict setObject:des forKey:kDescript];
        [mdict setObject:res forKey:kComeout];
        [mdict setObject:@(YES) forKey:kIsMust];
        [marr addObject:[mdict copy]];
    }
    return [marr copy];
}

-(NSArray *)specialDayBeforeSeason
{
    
    NSMutableArray *marr = [NSMutableArray array];
    NSString *des = @"四绝日";
    NSString *res = @"减寿五年";
    NSArray *season = @[@"立春",@"立夏",@"立秋",@"立冬"];
    for (NSString *s in season)
    {
        NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
        NSString *time = [self timeAttentionSolar:s];
        [mdict setObject:time forKey:kTabooStart];
        [mdict setObject:@(-1) forKey:kDuration];
        [mdict setObject:des forKey:kDescript];
        [mdict setObject:res forKey:kComeout];
        [mdict setObject:@(YES) forKey:kIsMust];
        [marr addObject:[mdict copy]];
    }
    return [marr copy];
}


@end
