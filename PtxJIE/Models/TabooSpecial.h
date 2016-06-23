//
//  TabooSpecial.h
//  PtxJIE
//
//  Created by ptx on 16/6/23.
//  Copyright © 2016年 fido0725. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TabooSpecial : NSManagedObject

@property (nullable, nonatomic, retain) NSString *day;
@property (nullable, nonatomic, retain) NSString *month;
@property (nullable, nonatomic, retain) NSString *year;

@end
