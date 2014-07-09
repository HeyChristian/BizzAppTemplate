//
//  TimeCardCellViewCell.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/8/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeCardCellViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeInLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeOutLabel;

-(void)configureCellForEntry:(NSMutableDictionary *)dictionary;

@end
