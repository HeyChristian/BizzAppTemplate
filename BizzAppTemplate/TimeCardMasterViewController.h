//
//  TimeCardMasterViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/8/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface TimeCardMasterViewController : UITableViewController


@property(nonatomic)NSMutableArray *source;
@property(retain) NSMutableArray* tableViewSections;
@property(retain) NSMutableDictionary* tableViewCells;

@end
