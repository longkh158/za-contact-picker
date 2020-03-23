//
//  ViewController.m
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstants.h"
#import "ViewController.h"
#import "ContactTableViewController.h"
#import "ContactSearchController.h"
#import "ContactTableCellViewModel.h"
#import "ContactPickerController.h"

@interface ViewController ()

@property NSMutableArray<ContactTableCellViewModel *> *selectedContacts;

@property (nonatomic) ContactTableViewController *contactsVC;
@property (nonatomic) ContactPickerController *pickerVC;
@property (nonatomic) ContactSearchController *search;
@property (nonatomic) UIStackView *navbarTitle;
@property (nonatomic) UILabel *selectedCountLabel;

- (void)setupSearchBar;
- (void)setupContactsList;
- (void)updateSelectedLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialize];
    [self setupContactsList];
    [self setupNavigationBar];
    [self.contactsVC attachSearchController:self.search];
    self.pickerVC = [[ContactPickerController alloc] initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    [self.pickerVC attachViewModel:self.selectedContacts];
    [self addChildViewController:self.pickerVC];
    [self.view addSubview:self.pickerVC.view];
}

#pragma mark - View Setup

- (void)initialize
{
    self.selectedContacts = [NSMutableArray arrayWithCapacity:CONTACTS_SELECTION_LIMIT];
}

//! Prepare navigation bar
- (void)setupNavigationBar
{
    [self setupNavbarTitle];
    [self setupSearchBar];
    self.navigationItem.titleView = self.navbarTitle;
}

- (void)setupNavbarTitle
{
    self.navbarTitle = [[UIStackView alloc] init];
    self.navbarTitle.axis = UILayoutConstraintAxisVertical;
    self.navbarTitle.alignment = UIStackViewAlignmentCenter;
    self.selectedCountLabel = [[UILabel alloc] init];
    self.selectedCountLabel.textColor = [UIColor secondaryLabelColor];
    self.selectedCountLabel.hidden = YES;
    [self.selectedCountLabel setFont:[UIFont systemFontOfSize:11]];
    UILabel *mainLabel = [[UILabel alloc] init];
    mainLabel.text = @"Pick Contact";
    [self.navbarTitle addArrangedSubview:mainLabel];
    [self.navbarTitle addArrangedSubview:self.selectedCountLabel];
}

//! Prepare contacts list and display
- (void)setupContactsList
{
    self.contactsVC = [[ContactTableViewController alloc] init];
    [self addChildViewController:self.contactsVC];
    [self.view addSubview:self.contactsVC.view];
}

//! Prepare search controller
- (void)setupSearchBar
{
    self.search = [[ContactSearchController alloc] initWithSearchResultsController:nil];
    self.search.searchResultsUpdater = self.contactsVC;
    self.search.delegate = self.contactsVC;
    self.search.mainVC = self;
    self.navigationItem.searchController = self.search;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
}

- (void)addContactViewModel:(ContactTableCellViewModel *)vm
{
    NSUInteger idx = [self.selectedContacts indexOfObjectPassingTest:
                      ^BOOL(ContactTableCellViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        return obj.identifier == vm.identifier;
    }];
    if (idx == NSNotFound)
    {
        [self.selectedContacts addObject:vm];
        NSLog(@"currently having %lu element(s)", [self.selectedContacts count]);
    }
    [self updateSelectedLabel];
}

- (void)removeContactViewModel:(ContactTableCellViewModel *)vm
{
    NSUInteger idx = [self.selectedContacts indexOfObjectPassingTest:
                      ^BOOL(ContactTableCellViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        return obj.identifier == vm.identifier;
    }];
    if (idx != NSNotFound)
    {
        [self.selectedContacts removeObjectAtIndex:idx];
        NSLog(@"currently having %lu element(s)", [self.selectedContacts count]);
    }
    [self updateSelectedLabel];
}

- (void)updateSelectedLabel
{
    NSUInteger count = [self.selectedContacts count];
    if (count == 0)
    {
        self.selectedCountLabel.hidden = YES;
    }
    else
    {
        self.selectedCountLabel.hidden = NO;
        self.selectedCountLabel.text = [NSString stringWithFormat:@"Selected: %lu/%lu", count, CONTACTS_SELECTION_LIMIT];
    }
}

@end
