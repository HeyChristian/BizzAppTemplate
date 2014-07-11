//
//  TaskNoteCell.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/10/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskNoteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *task;
+(CGFloat)heightForEntry:(NSDictionary *)row;
-(void)configureCellForEntry:(NSDictionary *)row;
@end
