//
//  TimeFilterViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/12/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "TimeFilterViewController.h"
#import "Tools.h"
#import "UIViewController+KNSemiModal.h"
//#import "MNCalendarView.h"
//#import "VRGCalendarView.h"
#import "DSLCalendarView.h"
//#import "DTCalendarViewController.h"

@interface TimeFilterViewController ()<DSLCalendarViewDelegate>{
    
    NSDate *fromDate;
    NSDate *toDate;
    
    
}

@end

@implementation TimeFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.calendarView.delegate=self;
   
    
    NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:self.calendarView.visibleMonth.calendar];
    self.calendarView.selectedRange = [[DSLCalendarRange alloc] initWithStartDay:today endDay:today];
  
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewAllAction:(id)sender {
    [self.delegate ApplyTimeRangeFilter:nil andEndDate:nil];
    [self dismissSemiModalView];
}

- (IBAction)selectTimeFrameAction:(id)sender {
    [self.delegate ApplyTimeRangeFilter:fromDate andEndDate:toDate];
    [self dismissSemiModalView];
}

#pragma mark - DSLCalendarViewDelegate methods

- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range {
    if (range != nil) {
        NSLog( @"Selected %ld/%ld - %ld/%ld", (long)range.startDay.day, (long)range.startDay.month, (long)range.endDay.day, (long)range.endDay.month);
        fromDate =  range.startDay.date;
        toDate   =  range.endDay.date;
        
    }
    else {
        NSLog( @"No selection" );
    }
}

- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range {
    if (NO) { // Only select a single day
        return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
    }
    else if (NO) { // Don't allow selections before today
        NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
        
        NSDateComponents *startDate = range.startDay;
        NSDateComponents *endDate = range.endDay;
        
        if ([self day:startDate isBeforeDay:today] && [self day:endDate isBeforeDay:today]) {
            return nil;
        }
        else {
            if ([self day:startDate isBeforeDay:today]) {
                startDate = [today copy];
            }
            if ([self day:endDate isBeforeDay:today]) {
                endDate = [today copy];
            }
            
            return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
        }
    }
    
    return range;
}

- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration {
    NSLog(@"Will show %@ in %.3f seconds", month, duration);
}

- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month {
    NSLog(@"Now showing %@", month);
}

- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}

-(NSDate *) startOfMonth
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDateComponents * currentDateComponents = [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate:[NSDate date]];
    NSDate * startOfMonth = [calendar dateFromComponents: currentDateComponents];
    
    return startOfMonth;
}
- (NSDate *) endOfMonth
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDate * plusOneMonthDate = [self dateByAddingMonths: 1];
    NSDateComponents * plusOneMonthDateComponents = [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate: plusOneMonthDate];
    NSDate * endOfMonth = [[calendar dateFromComponents: plusOneMonthDateComponents] dateByAddingTimeInterval: -1]; // One second before the start of next month
    
    return endOfMonth;
}
- (NSDate *) dateByAddingMonths: (NSInteger) monthsToAdd
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDateComponents * months = [[NSDateComponents alloc] init];
    [months setMonth: monthsToAdd];
    
    return [calendar dateByAddingComponents: months toDate:[NSDate date] options: 0];
}
-(NSDateComponents *)getStartDayOfMonth{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
   return  [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate:[self startOfMonth]];
}
-(NSDateComponents *)getEndDayOfMonth{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    return  [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate:[self endOfMonth]];
}
@end
