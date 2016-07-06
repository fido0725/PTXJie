//
//  TableViewController.m
//  PtxJIE
//
//  Created by ptx on 16/6/19.
//  Copyright © 2016年 fido0725. All rights reserved.
//

#import "TableViewController.h"
#import "Store.h"
#import "Reader.h"
#import "NSString+ParseCSV.h"
#import "TabooNormal.h"
#import "PtxCalendar.h"
#import "TabooSpecial.h"
#import "LunarCalendar.h"
#import "TabooSolar.h"

@interface TableViewController ()
@property (nonatomic,strong) Store *store;
@property (nonatomic,strong) NSManagedObjectContext *privateManagedContext;
@property (nonatomic,strong) NSManagedObjectContext *mainManagedContext;
@property (nonatomic,strong) PtxCalendar *calendar;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) Reader *reader;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.store = [[Store alloc]init];
    self.mainManagedContext = self.store.mainManagedObjectContext;
    self.privateManagedContext = [self.store newPrivateContext];
    NSNumber *num = [[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstLoad"];
    if ([num integerValue]) {
        self.calendar = [PtxCalendar current];
        [self setDataSourceWithCalendar];
        [self.tableView reloadData];
    }
    else
    {
        [self loadTextInCordata];
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadTextInCordata
{
    
    self.reader = [[Reader alloc]initWithFileAtURL:[[NSBundle mainBundle ] URLForResource:@"TabooInYear" withExtension:@"txt"]];
    NSMutableArray *managedObjects = [[NSMutableArray alloc]init];
    __block NSString *month;
    [self.reader enumerateLinesWithBlock:^(NSUInteger lineNumber, NSString *line) {
        NSArray *array = [line csvComponents];
        if (array.count == 1) {
            month = array[0];//xxx月或特殊日
            return ;
        }
        NSRange monthRang = [month rangeOfString:@"月"];
        if (monthRang.location != NSNotFound) {
            NSEntityDescription *entityDes = [NSEntityDescription entityForName:@"TabooNormal" inManagedObjectContext:self.privateManagedContext];
            TabooNormal *taboo = (TabooNormal *)[[NSManagedObject alloc]initWithEntity:entityDes insertIntoManagedObjectContext:self.privateManagedContext];
            taboo.month = month;
            taboo.day = array[0];
            taboo.origins = array[1];
            taboo.outcome = array[2];
            [managedObjects addObject:taboo];

        }
        else
        {
            NSEntityDescription *entityDes = [NSEntityDescription entityForName:@"TabooSpecial" inManagedObjectContext:self.privateManagedContext];
            TabooSpecial *taboo = (TabooSpecial *)[[NSManagedObject alloc]initWithEntity:entityDes insertIntoManagedObjectContext:self.privateManagedContext];
            NSInteger count = array.count;
            taboo.day =count>0? array[0]:@"";
            taboo.month =count>1? array[1]:@"";
            taboo.year = count>2? array[2]:@"";
            [managedObjects addObject:taboo];
        }
        if (lineNumber%30 == 0) {
            [self.privateManagedContext save:NULL];
            [managedObjects removeAllObjects];
        }
    } completionHandler:^(NSUInteger numberOfLines) {
        [self.privateManagedContext save:NULL];
        [self loadSolarData];
        [[NSUserDefaults standardUserDefaults] setValue:@1 forKey:@"isFirstLoad"];
        [[NSUserDefaults standardUserDefaults] synchronize];
            self.calendar = [PtxCalendar current];
            [self setDataSourceWithCalendar];
            self.reader = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];

}

-(void)loadSolarData
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
   NSString *year = [formatter stringFromDate:date];
    LunarCalendar *lunarCalendar = [[LunarCalendar alloc]init];
    NSArray *list;
    [lunarCalendar ComputeSolarTermForYear:[year intValue] intoList:&list];
    NSMutableArray *managedObjects = [NSMutableArray array];
    for (NSDictionary *dict in list) {
        NSEntityDescription *entityDes = [NSEntityDescription entityForName:@"TabooSolar" inManagedObjectContext:[NSThread isMainThread]?self.mainManagedContext:self.privateManagedContext];
        TabooSolar *taboo = (TabooSolar *)[[NSManagedObject alloc]initWithEntity:entityDes insertIntoManagedObjectContext:[NSThread isMainThread]?self.mainManagedContext:self.privateManagedContext];
        taboo.solarDate = dict[@"solarDate"];
        taboo.solarName = dict[@"solarName"];
        [managedObjects addObject:taboo];
    }
    NSManagedObjectContext *managedContext = [NSThread isMainThread]?self.mainManagedContext:self.privateManagedContext;
        [managedContext save:NULL];
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(void)setDataSourceWithCalendar
{
    if (self.calendar == nil) {
        return;
    }
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:[@(self.calendar.year) stringValue]];
    [self.dataSource addObject:[@(self.calendar.month) stringValue]];
    [self.dataSource addObject:[@(self.calendar.day) stringValue]];
    [self.dataSource addObject:[@(self.calendar.weekday) stringValue]];
    [self.dataSource addObject:[@(self.calendar.weekOfMonth) stringValue]];

    [self.dataSource addObject:self.calendar.cn_year];
    [self.dataSource addObject:self.calendar.cn_month];
    [self.dataSource addObject:self.calendar.cn_day];
    
    if (self.calendar.tabooNormal) {
        [self.dataSource addObject:self.calendar.tabooNormal.month];
        [self.dataSource addObject:self.calendar.tabooNormal.day];
        [self.dataSource addObject:self.calendar.tabooNormal.origins];
        [self.dataSource addObject:self.calendar.tabooNormal.outcome];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
