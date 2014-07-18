//
//  LocationCell.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/17/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ClientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;

-(void)configureCellForEntry:(NSDictionary *)row;
@end
