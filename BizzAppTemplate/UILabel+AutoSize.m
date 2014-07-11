//
//  UILabel+AutoSize.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/11/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "UILabel+AutoSize.h"

@implementation UILabel (AutoSize)
- (void) autosizeForWidth: (int) width {
   // self.lineBreakMode = UILineBreakModeWordWrap;
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    self.numberOfLines = 0;
  //  CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
   // CGSize expectedLabelSize = [self.text sizeWithFont:self.font constrainedToSize:maximumLabelSize lineBreakMode:self.lineBreakMode];
    
    CGSize expectedLabelSize = [self.text sizeWithAttributes:
                   @{NSFontAttributeName:
                         [UIFont systemFontOfSize:17.0f]}];
    
    CGRect newFrame = self.frame;
    newFrame.size.height = expectedLabelSize.height;
    self.frame = newFrame;
}
@end
