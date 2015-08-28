//
//  ViewController.m
//  PtxJIE
//
//  Created by chenfeng on 15/8/19.
//  Copyright (c) 2015年 fido0725. All rights reserved.
//

#import "ViewController.h"
#import "PtxCalendar.h"
#import "CalendarCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    PtxCalendar *_calendarModel;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *datasource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _calendarModel = [PtxCalendar current];
    _datasource = [_calendarModel allMonth];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_datasource[section] count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    PtxCalendar *model = _datasource[indexPath.section][indexPath.item];
    cell.dayLabel.text = @(model.day).stringValue;
    cell.lunarLabel.text = model.cn_day;
    return cell;
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _datasource.count;
}
@end
