//
//  TabooNormal.h
//  PtxJIE
//
//  Created by ptx on 16/6/19.
//  Copyright © 2016年 fido0725. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TabooNormal : NSManagedObject

@property (nullable, nonatomic, retain) NSString *day;
@property (nullable, nonatomic, retain) NSString *month;
@property (nullable, nonatomic, retain) NSString *origins;
@property (nullable, nonatomic, retain) NSString *outcome;

@end
