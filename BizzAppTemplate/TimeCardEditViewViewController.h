//
//  TimeCardEditViewViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/10/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+KNSemiModal.h"

@class WarningCheckOutViewController;

@interface TimeCardEditViewViewController : UITableViewController{
    WarningCheckOutViewController *warningView;
}


@property(nonatomic)NSMutableDictionary  *timeCard;

@property (weak, nonatomic) IBOutlet UIButton *checkOutButton;
@property (weak, nonatomic) IBOutlet UITableViewCell *warningCell;

@property (weak, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *taskDescription;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkinLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *countTaskNoteLabel;

@property (nonatomic) NSMutableArray *notes;
- (IBAction)checkOutAction:(id)sender;

- (IBAction)viewWarningGeoLocationAction:(id)sender;

@end
