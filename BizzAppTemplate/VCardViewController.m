//
//  VCardViewController.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 6/30/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "VCardViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "vCardSerialization.h"
#import "HomeViewController.h"
#import <AddressBookUI/AddressBookUI.h>

@interface VCardViewController ()<UINavigationControllerDelegate,ABPersonViewControllerDelegate>{
   UINavigationController *navigationViewController;
   HomeViewController *root;
    
}
@end

@implementation VCardViewController

@synthesize parentVC = _parentVC;


- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    // Do any additional setup after loading the view from its nib.
}


-(void)viewDidAppear:(BOOL)animated{
   
    [super viewDidAppear:animated];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewContact:(id)sender {
    
   // UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"ChristianVazquez" withExtension:@"vcf"];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    
    NSArray *records = [vCardSerialization addressBookRecordsWithVCardData:data error:nil];
    
    ABPersonViewController *viewController = [[ABPersonViewController alloc] init];
    viewController.displayedPerson = (__bridge ABAddressBookRef)[records firstObject];
    viewController.allowsEditing =  NO;
    viewController.personViewDelegate= self;
    viewController.title = @"V-Card";
    
    
    ABNewPersonViewController *navPerson = [[ABNewPersonViewController alloc] init];
    navPerson.displayedPerson =  (__bridge ABAddressBookRef)[records firstObject];
    navPerson.title = @"V-Card";
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.parentVC];
    [nav pushViewController:viewController animated:YES];
  
    [self presentViewController:nav animated:YES completion:nil];

    
}
-(BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return YES;
}
-(void)dismiss:(id)sender{
    
   //[[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:NO completion:nil];
   
    
}

- (IBAction)downloadVCard:(id)sender {
   
  // ABAddressBookRef iPhoneAddressBook = ABAddressBookCreateWithOptions(NULL,NULL);
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"ChristianVazquez" withExtension:@"vcf"];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    
    NSArray *records = [vCardSerialization addressBookRecordsWithVCardData:data error:nil];
    
    ABRecordRef newPerson = (__bridge ABAddressBookRef)[records firstObject];
    
 
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(newPerson, kABPersonFirstNameProperty) ;
    NSString *surname = (__bridge NSString *)ABRecordCopyValue(newPerson, kABPersonLastNameProperty) ;

    
    ABAddressBookRef adbk = ABAddressBookCreateWithOptions(NULL,NULL);
    ABRecordRef moi = NULL;
    
    
    
    CFArrayRef person = ABAddressBookCopyPeopleWithName(adbk, (__bridge CFStringRef)(firstName));
    // might be multiple matts, but let's find the one with last name Neuburg
    for (CFIndex ix = 0; ix < CFArrayGetCount(person); ix++) {
        ABRecordRef matt = CFArrayGetValueAtIndex(person, ix);
        CFStringRef last = ABRecordCopyValue(matt, kABPersonLastNameProperty);
        if (last && CFStringCompare(last, (CFStringRef)surname, 0) == 0)
            moi = person;
        if (last)
            CFRelease(last);
    }
    if (NULL == moi) {
        
      //  NSLog(@"Couldn't find myself");
        
        ABAddressBookAddRecord(adbk, newPerson, nil);
        ABAddressBookSave(adbk, nil);
        
        CFRelease(person);
        CFRelease(adbk);
        
        return;
    
    
    }
    // parse my emails
    /*
    ABMultiValueRef emails = ABRecordCopyValue(moi, kABPersonEmailProperty);
    for (CFIndex ix = 0; ix < ABMultiValueGetCount(emails); ix++) {
        CFStringRef label = ABMultiValueCopyLabelAtIndex(emails, ix);
        CFStringRef value = ABMultiValueCopyValueAtIndex(emails, ix);
        NSLog(@"I have a %@ address: %@", label, value);
        CFRelease(label);
        CFRelease(value);
    }*/
    
    
    if(moi==nil){
        moi=newPerson;
    }
    
     ABAddressBookAddRecord(adbk, newPerson, nil);
      ABAddressBookSave(adbk, nil);
    
    
    
    NSLog(@"SAVE");
    [self dismissSemiModalView];
    
    
}
@end
