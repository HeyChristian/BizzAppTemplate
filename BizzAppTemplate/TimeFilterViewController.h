//
//  TimeFilterViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/12/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSLCalendarView.h"

@interface TimeFilterViewController : UIViewController

@property (weak, nonatomic) IBOutlet DSLCalendarView *calendarView;
- (IBAction)viewAllAction:(id)sender;
- (IBAction)selectTimeFrameAction:(id)sender;
@end
