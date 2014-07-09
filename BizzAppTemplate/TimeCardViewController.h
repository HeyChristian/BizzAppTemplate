//
//  TimeCardViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/8/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeCardViewController : UITableViewController


@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;

@property (weak, nonatomic) IBOutlet UITextField *clientField;

@property (weak, nonatomic) IBOutlet UITextView *taskDescriptionsField;


- (IBAction)checkInAction:(id)sender;

@end
