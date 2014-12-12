//
//  LocationTableViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/17/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "LocationTableViewController.h"
#import "Tools.h"
#import <Parse/Parse.h>
#import "MenuNavigationController.h"
#import "TCEmptyCell.h"
#import "LocationCell.h"
#import "Tools.h"
#import "MapSharedDetails.h"
#import "UIViewController+KNSemiModal.h"

@interface LocationTableViewController ()

@end

@implementation LocationTableViewController

#define rowHeight   122
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationItem.title  = @"Shared Location";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu48"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(MenuNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.showAll = NO;
    [self bindSource:self.showAll];
    [self groupByTimeAgo];
    [self.tableView reloadData];
    
      mapView = [[MapSharedDetails alloc] initWithNibName:@"MapSharedDetails" bundle:nil];
    
}
-(void) bindSource:(bool)isRead{
    
    self.source = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"SharedLocation"];
    if(!isRead){
       [query whereKey:@"isOpen" equalTo:@NO];
    }else{
        [query setLimit:10];
    }
    [query orderByDescending:@"createdAt"];
 
    NSArray *list;
    for(PFObject *dic in [query findObjects]){
      
       
        [dic setObject:[Tools timeIntervalWithStartDate:dic.createdAt] forKey:@"elapse"];
        
        NSString *uid = [[dic objectForKey:@"sendUser"] objectId];
       
        PFQuery *qry = [PFUser query];
        [qry whereKey:@"objectId" equalTo:uid];
        
        list =[qry findObjects];
        if([list count]>0){
            [dic setObject:[list objectAtIndex:0] forKey:@"user"];
        }
        [self.source addObject:dic];
    }
    
    
}
-(void)groupByTimeAgo{
    NSMutableArray *headersUnSorted = [[NSMutableArray alloc] init];
    for(NSMutableDictionary *row in self.source){
        // NSLog(@"Row: %@", row);
        [headersUnSorted addObject:[row objectForKey:@"elapse"]];
    }
    
    self.tableViewSections = [NSMutableArray arrayWithCapacity:0];
    self.tableViewCells = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableArray* tableViewCellsForSection = nil;
    
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    bool exist=false;
    for(NSString *title in headersUnSorted){
        exist=false;
        if([headers count]!=0){
            for(NSString *temp in headers){
                if([temp isEqualToString:title]){
                    exist=true;
                }
            }
            
        }
        if(!exist){
            tableViewCellsForSection = [NSMutableArray arrayWithCapacity:0];
            [self.tableViewSections addObject:title];
            [self.tableViewCells setObject:tableViewCellsForSection forKey:title];
            [headers addObject:title];
        }
        [tableViewCellsForSection addObject:title];
    }
    
}
#pragma mark - Table view data source

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
    // NSLog(@"Section: %lu",(unsigned long)self.tableViewSections.count);
    
    return  self.tableViewSections.count == 0 ? 1:self.tableViewSections.count;
    
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    /*id key = [self.tableViewSections objectAtIndex:section];
    NSArray* tableViewCellsForSection = [self.tableViewCells objectForKey:key];
    if(tableViewCellsForSection.count == 0){
        return 1;
    }else{
        //  NSLog(@"Rows: %lu",(unsigned long)tableViewCellsForSection.count);
        return tableViewCellsForSection.count;
    }*/
    
    
    if([self.source count] == 0){
        
        return 1;
        
    }else{
        
        id key = [self.tableViewSections objectAtIndex:section];
        NSArray* tableViewCellsForSection = [self.tableViewCells objectForKey:key];
        
      //  NSLog(@"Rows: %lu",(unsigned long)tableViewCellsForSection.count);
        return tableViewCellsForSection.count;
        
    }
    
}
- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{

    return [self.tableViewSections count]==0?@"":[self.tableViewSections objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TCEmptyCell  *emptyCell;
    LocationCell  *cell;
    
    
    
    
    if ([self.source count] == 0) {
        
        emptyCell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell" forIndexPath:indexPath];
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor whiteColor];
        
    }else{
        
        NSInteger rowNumber = 0;
        
        for (NSInteger i = 0; i < indexPath.section; i++) {
            rowNumber += [self tableView:tableView numberOfRowsInSection:i];
        }
        
        rowNumber += indexPath.row;
        
        self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [cell configureCellForEntry:[self.source objectAtIndex:rowNumber]];
        
       
        
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, rowHeight, 320, .5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:line];
        
        
        
    }
    return ([self.source count] == 0 ? emptyCell:cell);
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}



- (IBAction)chooseSourceSegment:(id)sender {
   
    NSNumber *index = [[NSNumber alloc] initWithInteger:[self.filterSegment selectedSegmentIndex]];
    
    switch ([index intValue]) {
        case 0:
            [self bindSource:NO];
            break;
        case 1:
            [self bindSource:YES];
            break;
        default:
            break;
    }
    
    [self groupByTimeAgo];
    [self.tableView reloadData];
}
- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath{
    
    
    NSInteger rowNumber = 0;
    
    for (NSInteger i = 0; i < indexPath.section; i++) {
        rowNumber += [self tableView:tableView numberOfRowsInSection:i];
    }
    
    rowNumber += indexPath.row;
   
    mapView.sharedLocation = [self.source objectAtIndex:rowNumber];

    [self presentSemiViewController:mapView withOptions:@{
                                                              KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                              KNSemiModalOptionKeys.animationDuration : @(0.5),
                                                              KNSemiModalOptionKeys.shadowOpacity     : @(0.9),
                                                              }];
    
    
}
@end
