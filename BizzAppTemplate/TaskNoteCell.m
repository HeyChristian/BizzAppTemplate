//
//  TaskNoteCell.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/10/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "TaskNoteCell.h"
#import "Tools.h"
#import "UILabel+AutoSize.h"

@implementation TaskNoteCell


-(void)configureCellForEntry:(NSDictionary *)row{
    
    NSString *strdate = [Tools formatDateTime:[row objectForKey:@"date"]];
    NSString *strdetail =[row objectForKey:@"note"];
    
    self.dateLabel.text =strdate;
    self.task.text = strdetail;

    
    
}
+(CGFloat)heightForEntry:(NSDictionary *)row{
    
    const CGFloat topMargin = 35.0f;
    const CGFloat bottomMargin = 80.0f;
    const CGFloat minHeight = 85.0f;
    
    NSString *body = [row objectForKey:@"note"];
    
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGRect boundingBox = [body boundingRectWithSize:CGSizeMake(202,CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil];
    
    
    return MAX(minHeight,CGRectGetHeight(boundingBox) + topMargin + bottomMargin);
    
}
@end
