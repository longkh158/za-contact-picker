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

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

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
    [self setupNavigationBar];
    [self.contactsVC attachSearchController:self.search];
    self.pickerVC.parent = self;
    [self.pickerVC attachViewModel:self.selectedContacts];
    self.sendButton.backgroundColor = [UIColor systemBlueColor];
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.layer.cornerRadius = self.sendButton.frame.size.width / 2.0;
}

#pragma mark - View Setup

- (ContactPickerController *)getPickerController
{
    NSUInteger idx = [self.childViewControllers indexOfObjectPassingTest:^BOOL(__kindof UIViewController * _Nonnull controller, NSUInteger idx, BOOL * _Nonnull stop)
    {
        return [controller isKindOfClass:[ContactPickerController class]];
    }];
    return self.childViewControllers[idx];
}

- (UIViewController *)getControllerWithClass:(Class)class
{
    NSUInteger idx = [self.childViewControllers indexOfObjectPassingTest:^BOOL(__kindof UIViewController * _Nonnull controller, NSUInteger idx, BOOL * _Nonnull stop)
    {
        return [controller isKindOfClass:class];
    }];
    return self.childViewControllers[idx];
}

- (void)initialize
{
    self.selectedContacts = [NSMutableArray arrayWithCapacity:CONTACTS_SELECTION_LIMIT];
    self.pickerVC = [self getPickerController];
    self.contactsVC = (ContactTableViewController *)[self getControllerWithClass:[ContactTableViewController class]];
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
    [self.contactsVC.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
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
        [self.pickerVC refreshUI];
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
        [self.pickerVC refreshUI];
        [self.contactsVC refreshVM:vm];
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
