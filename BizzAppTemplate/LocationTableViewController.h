//
//  LocationTableViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/17/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MapSharedDetails;

@interface LocationTableViewController : UITableViewController{
    MapSharedDetails *mapView;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *filterSegment;
@property (nonatomic)NSMutableArray *source;
@property (nonatomic)bool showAll;
@property(retain) NSMutableArray* tableViewSections;
@property(retain) NSMutableDictionary* tableViewCells;


- (IBAction)chooseSourceSegment:(id)sender;
@end
