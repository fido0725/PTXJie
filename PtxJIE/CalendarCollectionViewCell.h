//
//  CalendarCollectionViewCell.h
//  PtxJIE
//
//  Created by chenfeng on 15/8/28.
//  Copyright (c) 2015年 fido0725. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *lunarLabel;

@end
