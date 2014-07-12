//
//  TimeCardCellViewCell.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/8/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "TimeCardCellViewCell.h"
#import "Tools.h"
@implementation TimeCardCellViewCell


-(void)configureCellForEntry:(NSMutableDictionary *)row{
        
    self.clientNameLabel.text = [[row objectForKey:@"client"] capitalizedString];
    self.addressLabel.text =[NSString stringWithFormat:@"%@ \n%@ \n%@",[row objectForKey:@"line1"],[row objectForKey:@"line2"],[row objectForKey:@"line3"]];
    self.timeInLabel.text = [row objectForKey:@"time_in"];
    self.timeOutLabel.text =  [[row objectForKey:@"time_out"] length]==0?@"Not Yet":[row objectForKey:@"time_out"];
    self.dateLabel.text = [NSString stringWithFormat:@"Date: %@",[Tools formatDate:[row objectForKey:@"checkin"]]];
    
}

@end
