//
//  VCardViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 6/30/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCardViewController : UIViewController{
    UIViewController *_parentVC;
}

@property (nonatomic)UIViewController *parentVC;

- (IBAction)viewContact:(id)sender;
- (IBAction)downloadVCard:(id)sender;

@end
