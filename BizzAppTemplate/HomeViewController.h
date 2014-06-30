//
//  HomeViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 6/29/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNGridMenu.h"

@interface HomeViewController : UIViewController <RNGridMenuDelegate>
- (IBAction)displayGridMenu:(id)sender;

@end
