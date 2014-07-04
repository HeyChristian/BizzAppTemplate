//
//  MenuNavigationController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/3/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "MenuNavigationController.h"
#import "MenuViewController.h"
#import "UIViewController+REFrostedViewController.h"


@interface MenuNavigationController ()

@property (strong, readwrite, nonatomic) MenuViewController *menuViewController;

@end

@implementation MenuNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

- (void)showMenu
{
    [self.frostedViewController presentMenuViewController];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    [self.frostedViewController panGestureRecognized:sender];
}

@end
