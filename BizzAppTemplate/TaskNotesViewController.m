//
//  TaskNotesViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/10/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "TaskNotesViewController.h"
#import "TCEmptyCell.h"
#import "TaskNoteCell.h"
#import <Parse/Parse.h>
#import "AddTaskViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "AddTaskViewController.h"
#import "Tools.h"

@interface TaskNotesViewController ()<AddTaskDelegate>

@end

@implementation TaskNotesViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    addTaskView = [[AddTaskViewController alloc] initWithNibName:@"AddTaskViewController" bundle:nil];
    addTaskView.delegate=self;
  
    
    if(self.objectId != nil){
        [self bindTaskSource];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:FALSE];
    [self.notes sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [self groupByTimeAgo];
    
    if(self.notes == nil){
        self.notes = [[NSMutableArray alloc] init];
    }
    
    if(self.isClose){
        [self.addTaskViewButton setHidden:YES];
    }else{
        [self.addTaskViewButton setHidden:NO];
    }

}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationItem.title  = @"Task Notes";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
  
    
    NSLog(@"Appear with %lu Records ",(unsigned long)[self.notes count]);
    [self.tableView reloadData];
    
  
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.tableViewSections.count == 0 ? 1:self.tableViewSections.count;
   // return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return ([self.notes count]==0?1:[self.notes count]);
    
    //id key = [self.tableViewSections objectAtIndex:section];
    //NSArray* tableViewCellsForSection = [self.tableViewCells objectForKey:key];
    
    
    if([self.notes count] == 0){
     
        return 1;
    
    }else{
    
        id key = [self.tableViewSections objectAtIndex:section];
        NSArray* tableViewCellsForSection = [self.tableViewCells objectForKey:key];
        
        NSLog(@"Rows: %lu",(unsigned long)tableViewCellsForSection.count);
        return tableViewCellsForSection.count;
    
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TCEmptyCell  *emptyCell;
    TaskNoteCell  *cell;
    
    
    
    
    if ([self.notes count] == 0) {
        
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
        [cell configureCellForEntry:[self.notes objectAtIndex:rowNumber]];
      
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 92, 320, .5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:line];
        
        
        
    }
    return ([self.notes count] == 0 ? emptyCell:cell);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.notes count] > 0){
        return 92;
    }else{
        return 203;
    }
    
}
#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

-(float)height :(NSString *)text
{
    
    CGSize size = [text sizeWithAttributes:
                   @{NSFontAttributeName:
                         [UIFont systemFontOfSize:FONT_SIZE]}];
    CGFloat height = MAX(size.height + CELL_CONTENT_MARGIN,50.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);
    
}
-(void) bindTaskSource{
    
    self.notes = [[NSMutableArray alloc] init];
    __block NSMutableDictionary *row = nil;
    
    PFQuery *query = [PFQuery queryWithClassName:@"TaskNote"];
    [query whereKey:@"TimeCard"
            equalTo:[PFObject objectWithoutDataWithClassName:@"TimeCard" objectId:self.objectId]];
    NSArray *objects = [query findObjects];
    
    for (PFObject *object in objects) {
        
        row = [[NSMutableDictionary alloc] init];
        [row setValue:object.objectId forKey:@"objectId"];
        [row setValue:object.createdAt forKey:@"date"];
        [row setValue:object[@"note"] forKey:@"note"];
        
        [self.notes addObject:row];
    }
    
}
- (IBAction)addTaskAction:(id)sender {
    
    addTaskView = [[AddTaskViewController alloc] initWithNibName:@"AddTaskViewController" bundle:nil];
    addTaskView.delegate=self;
    addTaskView.isNew=YES;
    addTaskView.titleLabel.text = @"New task note:";
    [addTaskView.addButton setHidden:NO];
     addTaskView.noteField.text = @"";
    [self presentSemiViewController:addTaskView withOptions:@{
                                                            KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                            KNSemiModalOptionKeys.animationDuration : @(0.5),
                                                            KNSemiModalOptionKeys.shadowOpacity     : @(0.9),
                                                            }];
    
}
// Tap on row accessory

- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath{

    //addTaskView = [[AddTaskViewController alloc] initWithNibName:@"AddTaskViewController" bundle:nil];
    addTaskView.isNew=false;
    addTaskView.titleLabel.text = @"Task note:";
    [addTaskView.addButton setHidden:YES];
    NSMutableDictionary *row = [self.notes objectAtIndex:indexPath.row];
    
    addTaskView.noteField.text = [row objectForKey:@"note"];
    addTaskView.note = [row objectForKey:@"note"];
    [self presentSemiViewController:addTaskView withOptions:@{
                                                              KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                              KNSemiModalOptionKeys.animationDuration : @(0.5),
                                                              KNSemiModalOptionKeys.shadowOpacity     : @(0.9),
                                                              }];


}
- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.tableViewSections count]==0?@"":[self.tableViewSections objectAtIndex:section];
}
-(void)updateTaskNoteList:(NSDate *)date andNote:(NSString *)note{
    
    
    if(self.objectId == nil){
    
        NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
        [row setObject:date forKey:@"date"];
        [row setObject:note forKey:@"note"];
        [self.notes addObject:row];
        
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:FALSE];
        [self.notes sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [self groupByTimeAgo];
        [self.tableView reloadData];
        
        [self.delegate updateNotes:self.notes];
    }else{
        PFQuery *timec = [PFQuery queryWithClassName:@"TimeCard"];
        [timec whereKey:@"objectId" equalTo:self.objectId];
        
        
        
        PFObject *tnote = [PFObject objectWithClassName:@"TaskNote"];
        tnote[@"TimeCard"] = [[timec findObjects] objectAtIndex:0];
        tnote[@"note"] = note;
        tnote[@"date"] = date;
        [tnote save];
        
        [self bindTaskSource];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:FALSE];
        [self.notes sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [self groupByTimeAgo];
        [self.tableView reloadData];
    }
   
}

-(void)groupByTimeAgo{
    NSMutableArray *headersUnSorted = [[NSMutableArray alloc] init];
    NSString *elapse=[[NSString alloc] init];
    for(NSMutableDictionary *row in self.notes){
        NSLog(@"Row: %@", row);
        
        elapse = [Tools timeIntervalWithStartDate:[row objectForKey:@"date"]];
        [headersUnSorted addObject:elapse];
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
@end
