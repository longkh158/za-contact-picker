//
//  ViewController.m
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ContactTableViewController.h"
#import "ContactSearchController.h"
#import "ContactSearchResultController.h"

@interface ViewController ()

@property (nonatomic) ContactTableViewController *contacts;
@property (nonatomic) ContactSearchController *search;
@property (nonatomic) ContactSearchResultController *searchResult;
@property (nonatomic) UIStackView *navbarTitle;
@property (nonatomic) UIBarButtonItem *editButton;

- (void)setupSearchBar;
- (void)setupContactsList;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupContactsList];
    [self setupNavigationBar];
}

#pragma mark - View Setup

//! Prepare navigation bar
- (void)setupNavigationBar
{
    [self setupNavbarTitle];
    [self setupBarButton];
    [self setupSearchBar];
    self.navigationItem.titleView = self.navbarTitle;
    self.navigationItem.leftBarButtonItem = self.editButton;
}

- (void)setupNavbarTitle
{
    self.navbarTitle = [[UIStackView alloc] init];
    self.navbarTitle.alignment = UIStackViewAlignmentCenter;
    UILabel *mainLabel = [[UILabel alloc] init];
    mainLabel.text = @"Pick Contact";
    [self.navbarTitle addArrangedSubview:mainLabel];
}

- (void)setupBarButton
{
    // TODO
}

//! Prepare contacts list and display
- (void)setupContactsList
{
    self.contacts = [[ContactTableViewController alloc] init];
    [self addChildViewController:self.contacts];
    [self.view addSubview:self.contacts.view];
}

//! Prepare search controller
- (void)setupSearchBar
{
    self.searchResult = [[ContactSearchResultController alloc] init];
    self.search = [[ContactSearchController alloc] initWithSearchResultsController:self.searchResult];
    self.navigationItem.searchController = self.search;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
}

@end
