//
//  MenuViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/3/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "MenuViewController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "TimeCardViewController.h"

#import "MenuNavigationController.h"
#import "UIViewController+REFrostedViewController.h"
#import <Parse/Parse.h>
#import "Tools.h"
#import "TimeCardMasterViewController.h"
#import "LocationTableViewController.h"
@interface MenuViewController ()

@end

@implementation MenuViewController


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self addHeaderViewInfo];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self addHeaderViewInfo];

}
-(void)addHeaderViewInfo{
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        /*
        PFFile *imageFile = [[PFUser currentUser] objectForKey:@"Image"];
        NSLog(@"Image Data URL: %@",imageFile.url);
        if(imageFile.url != nil){
            
            NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
            NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
            imageView.image = [UIImage imageWithData:imageData];
            
        }else{
            imageView.image=[UIImage imageNamed:@"profile2"];
        }*/
        
        
        imageView.image =  [Tools getProfileImage]; //[UIImage imageNamed:@"profile2"];
        
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        
        PFUser *user  = [PFUser currentUser];
        
        NSString *name = [[PFUser currentUser] objectForKey:@"Firstname"];
        NSString *last = [[PFUser currentUser] objectForKey:@"LastName"];
        
        NSString *displayName;
        
        if([name length]>0)
            displayName = [NSString stringWithFormat:@"%@ %@",name,last];
        else
            displayName = user[@"email"];
        
        
        label.text = displayName;
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });

}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Administration";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"iPhoneStoryboard" bundle:nil];
    HomeViewController *homeViewController = [mystoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    MenuNavigationController *navigationController=nil;
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        navigationController = [[MenuNavigationController alloc] initWithRootViewController:homeViewController];
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        //Profile
        
        ProfileViewController *profile = [mystoryboard instantiateViewControllerWithIdentifier:@"profileViewController"];
        navigationController = [[MenuNavigationController alloc] initWithRootViewController:profile];
        
        
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        //Settings
        
    }else if (indexPath.section == 0 && indexPath.row == 3) {
        //Log Out
        [PFUser logOut];
         navigationController = [[MenuNavigationController alloc] initWithRootViewController:homeViewController];
        
        
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        //Time Card
      TimeCardMasterViewController *timecard = [mystoryboard instantiateViewControllerWithIdentifier:@"TimeCardMasterViewController"];
         navigationController = [[MenuNavigationController alloc] initWithRootViewController:timecard];
        
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        //Shared Locations
        LocationTableViewController *location = [mystoryboard instantiateViewControllerWithIdentifier:@"LocationTableViewController"];
        navigationController = [[MenuNavigationController alloc] initWithRootViewController:location];
        
    }else if (indexPath.section == 1 && indexPath.row == 2) {
        //Manage Tickets
       
        
    }else {
        navigationController = [[MenuNavigationController alloc] initWithRootViewController:homeViewController];
    }
    
    
    
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    bool isAdmin=true;
    
    if(isAdmin)
        return 2;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"Home", @"Profile", @"Settings", @"Log out"];
        cell.textLabel.text = titles[indexPath.row];
    } else {
        NSArray *titles = @[@"Time Card",@"Shared Locations",@"Manage Tickets",@""];
        cell.textLabel.text = titles[indexPath.row];
    }
    
    return cell;
}

@end
