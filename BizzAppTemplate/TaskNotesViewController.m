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
  
    

}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationItem.title  = @"Task Notes";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
    if(self.objectId != nil){
        [self bindTaskSource];
    }
    
    NSLog(@"Appear with %lu Records ",(unsigned long)[self.notes count]);
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.notes count]==0?1:[self.notes count]);
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
        
        
        self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [cell configureCellForEntry:[self.notes objectAtIndex:indexPath.row]];
        /*
       
        NSMutableDictionary *row = [self.notes objectAtIndex:indexPath.row];
        NSString *detailString = [row objectForKey:@"note"];
        
        CGSize detailSize = [detailString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        
        float h= detailSize.height+50.0f;
        */
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 92, 320, .5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:line];
        
        
        
    }
    return ([self.notes count] == 0 ? emptyCell:cell);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.notes count] > 0){
    
        /*
        NSMutableDictionary *row = [self.notes objectAtIndex:indexPath.row];
        //CGFloat heightOfcell = [self height:[row objectForKey:@"note"]];
        //NSLog(@"%f",heightOfcell);
        //return heightOfcell;
        
     // return  [TaskNoteCell heightForEntry:[self.notes objectAtIndex:indexPath.row]];
       
        NSString *detailString = [row objectForKey:@"note"];
     
        CGSize detailSize = [detailString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        
        return detailSize.height+50.0f;
        */
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"TaskNotes"];
    [query whereKey:@"TaskNotes"
            equalTo:[PFObject objectWithoutDataWithClassName:@"TaskNotes" objectId:self.objectId]];
    NSArray *objects = [query findObjects];
    
    for (PFObject *object in objects) {
        
        row = [[NSMutableDictionary alloc] init];
        [row setValue:object.objectId forKey:@"objectId"];
        [row setValue:object.createdAt forKey:@"createdAt"];
        [row setValue:object[@"note"] forKey:@"note"];
        
        [self.notes addObject:row];
    }
    
}
- (IBAction)addTaskAction:(id)sender {
    
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

    addTaskView.isNew=NO;
    addTaskView.titleLabel.text = @"Task note:";
    [addTaskView.addButton setHidden:YES];
    NSMutableDictionary *row = [self.notes objectAtIndex:indexPath.row];
    
    addTaskView.noteField.text = [row objectForKey:@"note"];
    [self presentSemiViewController:addTaskView withOptions:@{
                                                              KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                              KNSemiModalOptionKeys.animationDuration : @(0.5),
                                                              KNSemiModalOptionKeys.shadowOpacity     : @(0.9),
                                                              }];


}
-(void)updateTaskNoteList:(NSDate *)date andNote:(NSString *)note{
    
    NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
    [row setObject:date forKey:@"date"];
    [row setObject:note forKey:@"note"];
    [self.notes addObject:row];
    
    [self.tableView reloadData];
    
    
    [self.delegate updateNotes:self.notes];
   
}


@end
