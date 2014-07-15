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
    
    //self.timeInLabel.text = [row objectForKey:@"time_in"];
    //self.timeOutLabel.text =  [[row objectForKey:@"time_out"] length]==0?@"Not Yet":[row objectForKey:@"time_out"];
    if([[row objectForKey:@"time_out"] length]==0){
        [self.InProgressLabel setHidden:NO];
        [self.workingFrameView setHidden:YES];
    }else{
        [self.InProgressLabel setHidden:YES];
        [self.workingFrameView setHidden:NO];
        
        NSMutableDictionary *wf = [row objectForKey:@"working_time"];
        self.timeInLabel.text = [NSString stringWithFormat:@"%@h",[wf objectForKey:@"hour"]];
        self.timeOutLabel.text = [NSString stringWithFormat:@"%@min",[wf objectForKey:@"minutes"]];
    }
    
    self.dateLabel.text = [NSString stringWithFormat:@"Date: %@",[Tools formatDate:[row objectForKey:@"checkin"]]];
    
}

@end
