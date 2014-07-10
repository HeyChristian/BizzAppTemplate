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

#define rowHeight   105

@interface TimeCardMasterViewController (){
    
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
    
    /*
     
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
     style:UIBarButtonItemStylePlain
     target:self
     action:@selector(update)];*/
    

    [self bindTimeCardTableSource];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkin" ascending:FALSE];
    [self.source sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [self groupByTimeAgo];
    [self.tableView reloadData];
  
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


-(void)groupByTimeAgo{
    NSMutableArray *headersUnSorted = [[NSMutableArray alloc] init];
    for(NSMutableDictionary *row in self.source){
        NSLog(@"Row: %@", row);
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
    return self.tableViewSections.count;
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    id key = [self.tableViewSections objectAtIndex:section];
    NSArray* tableViewCellsForSection = [self.tableViewCells objectForKey:key];
    if(tableViewCellsForSection.count == 0){
        return 1;
    }else{
        return tableViewCellsForSection.count;
    }
}
- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.tableViewSections objectAtIndex:section];
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
        
        
        self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [cell configureCellForEntry:[self.source objectAtIndex:indexPath.row]];
        
        NSLog(@"index path %lu",indexPath.row);
        
        
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
                //[row setValue:object[@"date_out"] forKey:@"date_out"];
                //[row setValue:object[@"time_out"] forKey:@"time_out"];
                [row setValue:object[@"client"] forKey:@"client"];
                [row setValue:object[@"line1"] forKey:@"line1"];
                [row setValue:object[@"line2"] forKey:@"line2"];
                [row setValue:object[@"line3"] forKey:@"line3"];
                [row setValue:object.createdAt forKey:@"createdAt"];
                [row setValue:object[@"checkin"] forKey:@"checkin"];
                [row setValue:[Tools timeIntervalWithStartDate:object.createdAt] forKey:@"elapse"];
                //[row setValue:object[@"checkout"] forKey:@"checkout"];
                
                [self.source addObject:row];
    }
    
}

@end
