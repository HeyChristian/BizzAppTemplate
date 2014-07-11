//
//  TaskNotesViewController.h
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/10/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AddTaskViewController;

@protocol TaskNoteDelegate <NSObject>
@optional
- (void) updateNotes:(NSMutableArray *)notes;
@end

@interface TaskNotesViewController : UITableViewController{
    AddTaskViewController *addTaskView;
}


@property (nonatomic, assign) id<TaskNoteDelegate>delegate; //create a delegate

@property (nonatomic) NSString *objectId;
@property (nonatomic) NSMutableArray *notes;

- (IBAction)addTaskAction:(id)sender;

@end
