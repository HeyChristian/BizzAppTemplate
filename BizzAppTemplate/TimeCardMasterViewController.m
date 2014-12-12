//
//  TimeCardMasterViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/8/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "TimeCardMasterViewController.h"
#import "MenuNavigationController.h"
#import <Parse/Parse.h>
#import "TCEmptyCell.h"
#import "TimeCardCellViewCell.h"
#import "Tools.h"
#import "TimeCardEditViewViewController.h"
#import "TimeFilterViewController.h"
#import "UIViewController+KNSemiModal.h"


#define rowHeight   105

@interface TimeCardMasterViewController ()<TimeFilterDelegate>{
    bool allInCheckout;
}

@end

@implementation TimeCardMasterViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}
-(void)viewDidAppear:(BOOL)animated{
   
    
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationItem.title  = @"Time Card History";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu48"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(MenuNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
    
     
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar48"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(showFilter)];
    

    [super viewDidLoad];
    [self bindTimeCardTableSource];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:FALSE];
    [self.source sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [self groupByTimeAgo];
    [self.tableView reloadData];
  
    
}
-(void)viewDidLoad{
     filterView = [[TimeFilterViewController alloc] initWithNibName:@"TimeFilterViewController" bundle:nil];
}

-(void)ApplyTimeRangeFilter:(NSDate *)startDate andEndDate:(NSDate *)endDate{
    
    [self bindTimeCardTableSource:startDate andToDate:endDate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:FALSE];
    [self.source sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [self groupByTimeAgo];
    [self.tableView reloadData];
    
}


#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
   if([segue.identifier isEqualToString:@"detailTimeCard"]){
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        TimeCardEditViewViewController  *edit = (TimeCardEditViewViewController *) segue.destinationViewController;
       
       NSInteger rowNumber = 0;
       
       for (NSInteger i = 0; i < indexPath.section; i++) {
           rowNumber += [self tableView:self.tableView numberOfRowsInSection:i];
       }
       
       rowNumber += indexPath.row;
       
       edit.timeCard = [self.source objectAtIndex:rowNumber];
        
    }
    
}

-(void)groupByTimeAgo{
    NSMutableArray *headersUnSorted = [[NSMutableArray alloc] init];
    for(NSMutableDictionary *row in self.source){
       // NSLog(@"Row: %@", row);
        [headersUnSorted addObject:[row objectForKey:@"elapse"]];
    }
    
    self.tableViewSections = [NSMutableArray arrayWithCapacity:0];
    self.tableViewCells = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableArray* tableViewCellsForSection = nil;
    
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    bool exist=false;
    for(NSString *title in headersUnSorted){
        exist=false;
        if([headers count]!=0){
            for(NSString *temp in headers){
                if([temp isEqualToString:title]){
                    exist=true;
                }
            }
          
        }
        if(!exist){
            tableViewCellsForSection = [NSMutableArray arrayWithCapacity:0];
            [self.tableViewSections addObject:title];
            [self.tableViewCells setObject:tableViewCellsForSection forKey:title];
            [headers addObject:title];
        }
        [tableViewCellsForSection addObject:title];
    }
    
}
- (void) setupDataSource
{
    NSMutableArray *unsortedDates = [[NSMutableArray alloc] init]; // [self.sections allKeys];
    
    for(NSMutableDictionary *row in self.source){
        // order.orderDate
        [unsortedDates addObject:[row objectForKey:@"checkin"]];
    }
    
    NSArray *sortedDateArray = [unsortedDates sortedArrayUsingSelector:@selector(compare:)];
    
    
    self.tableViewSections = [NSMutableArray arrayWithCapacity:0];
    self.tableViewCells = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.timeZone = calendar.timeZone;
    [dateFormatter setDateFormat:@"MMMM YYYY"];
    
    NSUInteger dateComponents = NSYearCalendarUnit | NSMonthCalendarUnit;
    NSInteger previousYear = -1;
    NSInteger previousMonth = -1;
    NSMutableArray* tableViewCellsForSection = nil;
    for (NSDate* date in sortedDateArray)
    {
        NSDateComponents* components = [calendar components:dateComponents fromDate:date];
        NSInteger year = [components year];
        NSInteger month = [components month];
        if (year != previousYear || month != previousMonth)
        {
            NSString* sectionHeading = [dateFormatter stringFromDate:date];
            [self.tableViewSections addObject:sectionHeading];
            tableViewCellsForSection = [NSMutableArray arrayWithCapacity:0];
            [self.tableViewCells setObject:tableViewCellsForSection forKey:sectionHeading];
            previousYear = year;
            previousMonth = month;
        }
        [tableViewCellsForSection addObject:date];
    }
}


#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
   // NSLog(@"Section: %lu",(unsigned long)self.tableViewSections.count);
    
    return  self.tableViewSections.count == 0 ? 1:self.tableViewSections.count;
    
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    id key = [self.tableViewSections objectAtIndex:section];
    NSArray* tableViewCellsForSection = [self.tableViewCells objectForKey:key];
    if(tableViewCellsForSection.count == 0){
        return 1;
    }else{
      //  NSLog(@"Rows: %lu",(unsigned long)tableViewCellsForSection.count);
        return tableViewCellsForSection.count;
    }*/
    
    
    
    if([self.source count] == 0){
        
        return 1;
        
    }else{
        
        id key = [self.tableViewSections objectAtIndex:section];
        NSArray* tableViewCellsForSection = [self.tableViewCells objectForKey:key];
        
       // NSLog(@"Rows: %lu",(unsigned long)tableViewCellsForSection.count);
        return tableViewCellsForSection.count;
        
    }
    
}
- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    //return [self.tableViewSections objectAtIndex:section];
    return [self.tableViewSections count]==0?@"":[self.tableViewSections objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TCEmptyCell  *emptyCell;
    TimeCardCellViewCell  *cell;
    
    
    
    
    if ([self.source count] == 0) {
        
        emptyCell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell" forIndexPath:indexPath];
        emptyCell.EmptyMessagelabel.text = @"No have any time cards in your records";
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor whiteColor];
        
    }else{
        
        NSInteger rowNumber = 0;
        
        for (NSInteger i = 0; i < indexPath.section; i++) {
            rowNumber += [self tableView:tableView numberOfRowsInSection:i];
        }
        
        rowNumber += indexPath.row;
        
        self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [cell configureCellForEntry:[self.source objectAtIndex:rowNumber]];
        
      //  NSLog(@"index path %lu",indexPath.section);
     
    //    NSLog(@"index row number: %lu",rowNumber);
        
        
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, rowHeight, 320, .5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:line];
        
       
        
    }
    return ([self.source count] == 0 ? emptyCell:cell);
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}
-(void) bindTimeCardTableSource{
    
    allInCheckout=true;
    NSObject *checkout = nil;
    self.source = [[NSMutableArray alloc] init];
    __block NSMutableDictionary *row = nil;
    
    PFQuery *query = [PFQuery queryWithClassName:@"TimeCard"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
  
    NSArray *objects = [query findObjects];
    for (PFObject *object in objects) {
        
        row = [[NSMutableDictionary alloc] init];
        [row setValue:object.objectId forKey:@"objectId"];
        [row setValue:object[@"date_in"] forKey:@"date_in"];
        [row setValue:object[@"time_in"] forKey:@"time_in"];
        [row setValue:object[@"date_out"] forKey:@"date_out"];
        [row setValue:object[@"tasks"] forKey:@"description"];
        [row setValue:object[@"client"] forKey:@"client"];
        [row setValue:object[@"line1"] forKey:@"line1"];
        [row setValue:object[@"line2"] forKey:@"line2"];
        [row setValue:object[@"line3"] forKey:@"line3"];
        [row setValue:object.createdAt forKey:@"createdAt"];
        [row setValue:object[@"checkin"] forKey:@"checkin"];
        [row setValue:[Tools timeIntervalWithStartDate:object.createdAt] forKey:@"elapse"];
        
        [row setValue:object[@"checkout"] forKey:@"checkout"];
        [row setValue:object[@"date_out"] forKey:@"date_out"];
        [row setValue:object[@"time_out"] forKey:@"time_out"];
        [row setValue:object[@"geoPoint"] forKey:@"geoPoint"];
        [row setValue:[self getTimeBetween:object[@"checkin"] andTo:object[@"checkout"]] forKey:@"working_time"];
        
        //NSLog(@"Working Hours: %@",[self getTimeBetween:object[@"checkin"] andTo:object[@"checkout"]]);
        
        checkout = object[@"checkout"];
        if(checkout==nil){
            allInCheckout=false;
        }
        
        [self.source addObject:row];
    }
    
    if(allInCheckout){
        [self.checkInButton setHidden:NO];
        [self.tableView.tableHeaderView setHidden:NO];
        self.automaticallyAdjustsScrollViewInsets = YES;
        
    }else{
        [self.checkInButton setHidden:YES];
        [self.tableView.tableHeaderView setHidden:YES];
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }

}

-(void)bindTimeCardTableSource:(NSDate *)fromDate andToDate:(NSDate *)toDate{
    
  
    if(fromDate == nil && toDate == nil){
        [self bindTimeCardTableSource];
      
    }else{
        
            
            allInCheckout=true;
            NSObject *checkout = nil;
            self.source = [[NSMutableArray alloc] init];
            __block NSMutableDictionary *row = nil;
            
          
            
            PFQuery *greeterQuery = [PFQuery queryWithClassName:@"TimeCard"];
            [greeterQuery whereKey:@"user" equalTo:[PFUser currentUser]];
            [greeterQuery whereKey:@"checkin" greaterThanOrEqualTo:fromDate];
            
            
            PFQuery *lessQuery = [PFQuery queryWithClassName:@"TimeCard"];
            [lessQuery whereKey:@"user" equalTo:[PFUser currentUser]];
            [lessQuery whereKey:@"checkout" greaterThanOrEqualTo:toDate];
            
           
            PFQuery *query = [PFQuery orQueryWithSubqueries:@[greeterQuery,lessQuery]];
           
            
            
            NSArray *objects = [query findObjects];
            for (PFObject *object in objects) {
                
                row = [[NSMutableDictionary alloc] init];
                [row setValue:object.objectId forKey:@"objectId"];
                [row setValue:object[@"date_in"] forKey:@"date_in"];
                [row setValue:object[@"time_in"] forKey:@"time_in"];
                [row setValue:object[@"date_out"] forKey:@"date_out"];
                [row setValue:object[@"tasks"] forKey:@"description"];
                [row setValue:object[@"client"] forKey:@"client"];
                [row setValue:object[@"line1"] forKey:@"line1"];
                [row setValue:object[@"line2"] forKey:@"line2"];
                [row setValue:object[@"line3"] forKey:@"line3"];
                [row setValue:object.createdAt forKey:@"createdAt"];
                [row setValue:object[@"checkin"] forKey:@"checkin"];
                [row setValue:[Tools timeIntervalWithStartDate:object.createdAt] forKey:@"elapse"];
                
                [row setValue:object[@"checkout"] forKey:@"checkout"];
                [row setValue:object[@"date_out"] forKey:@"date_out"];
                [row setValue:object[@"time_out"] forKey:@"time_out"];
                [row setValue:object[@"geoPoint"] forKey:@"geoPoint"];
                [row setValue:[self getTimeBetween:object[@"checkin"] andTo:object[@"checkout"]] forKey:@"working_time"];
                
                //NSLog(@"Working Hours: %@",[self getTimeBetween:object[@"checkin"] andTo:object[@"checkout"]]);
                
                checkout = object[@"checkout"];
                if(checkout==nil){
                    allInCheckout=false;
                }
                
                [self.source addObject:row];
            }
            
            if(allInCheckout){
                [self.checkInButton setHidden:NO];
                [self.tableView.tableHeaderView setHidden:NO];
                self.automaticallyAdjustsScrollViewInsets = YES;
                
            }else{
                [self.checkInButton setHidden:YES];
                [self.tableView.tableHeaderView setHidden:YES];
                self.automaticallyAdjustsScrollViewInsets = NO;
                
            }
    }
}

-(void)showFilter{
    
    filterView.delegate=self;
    [self presentSemiViewController:filterView withOptions:@{ KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                              KNSemiModalOptionKeys.animationDuration : @(0.5),
                                                              KNSemiModalOptionKeys.shadowOpacity     : @(0.9),
                                                            }];
}

-(NSMutableDictionary *)getTimeBetween:(NSDate *)fromDate andTo:(NSDate *)toDate{
    /*
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    NSDate *date1 = fromDate;
    NSDate *date2 = toDate;
    NSTimeInterval interval = [date2 timeIntervalSinceDate:date1];
    int hours = (int)interval / 3600;             // integer division to get the hours part
    int minutes = (interval - (hours*3600)) / 60; // interval minus hours part (in seconds) divided by 60 yields minutes
    return  [NSString stringWithFormat:@"%d:%02d", hours, minutes];
    */
    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:fromDate  toDate:toDate  options:0];
    
    NSLog(@"Break down: %ld min : %ld hours : %ld days : %ld months",(long)[breakdownInfo minute], (long)[breakdownInfo hour], (long)[breakdownInfo day], (long)[breakdownInfo month]);

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    long totalHours = ((long)[breakdownInfo day] * 24) + (long)[breakdownInfo hour];
    
    [dic setValue:[NSNumber numberWithLong:totalHours] forKey:@"hour"];
    [dic setValue:[NSNumber numberWithLong:[breakdownInfo minute]] forKey:@"minutes"];
    //[dic setValue:[NSNumber numberWithLong:[breakdownInfo day]] forKey:@"day"];
    //[dic setValue:[NSNumber numberWithLong:[breakdownInfo month]] forKey:@"month"];
    
    return dic;
}

@end
