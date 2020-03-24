//
//  ContactTableViewController.m
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Nimbus/NITableViewModel.h>
#import <Nimbus/NITableViewActions.h>
#import "ViewController.h"
#import "ContactTableViewController.h"
#import "ContactTableViewPresenter.h"
#import "ContactSearchController.h"
#import "ContactTableCell.h"
#import "AppConstants.h"

@interface ContactTableViewController () <UITableViewDelegate, NITableViewModelDelegate>

@property ContactTableViewPresenter *presenter;
@property NITableViewModel *model;
@property NITableViewModel *searchModel;

@property (weak, nonatomic) UISearchController *search;
@property (nonatomic) UIActivityIndicatorView *indicator;

- (void)toggleSelectedStateForCellAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ContactTableViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        self.tableView.allowsMultipleSelection = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactTableCell" bundle:nil] forCellReuseIdentifier:TABLE_CELL_REUSE_ID];
    [self.presenter attachView:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getContacts];
}

- (void)getContacts {
    [self.presenter getAllContacts];
}

#pragma mark - Initializers

- (void)setupView
{
    self.presenter = [[ContactTableViewPresenter alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionIndexColor = [UIColor systemGrayColor];
    [self setupIndicator];
}

- (void)setupIndicator {
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.indicator.hidesWhenStopped = YES;
    self.indicator.center = self.view.center;
    [self.view addSubview:self.indicator];
}

- (void)setupViewModel:(NITableViewModel *)model
            withSearch:(BOOL)showSearch
           withSummary:(BOOL)showSummary
{
    self.tableView.dataSource = model;
    [model setSectionIndexType:NITableViewModelSectionIndexAlphabetical
                            showsSearch:showSearch
                           showsSummary:showSummary];
    [self.tableView reloadData];
}

- (void)attachSearchController:(UISearchController * _Nonnull)controller
{
    if (controller)
    {
         self.search = controller;
    }
}

- (void)refreshVM:(ContactTableCellViewModel *)vm
{
    NSIndexPath *indexPath = [self.model indexPathForObject:vm];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDelegate Protocol

- (void)toggleSelectedStateForCellAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell)
    {
        [cell toggleSelect];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UITableViewHeaderFooterView *)view forSection:(NSInteger)section
{
    view.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NITableViewModel *model = self.search.isActive ? self.searchModel : self.model;
    ContactTableCellViewModel *vm = [model objectAtIndexPath:indexPath];
    ViewController *vc = (ViewController *)self.parentViewController;
    if (vm)
    {
        if ([vc respondsToSelector:@selector(addContactViewModel:)])
        {
            [vc addContactViewModel:vm];
            [self toggleSelectedStateForCellAtIndexPath:indexPath];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NITableViewModel *model = self.search.isActive ? self.searchModel : self.model;
    ContactTableCellViewModel *vm = [model objectAtIndexPath:indexPath];
    ViewController *vc = (ViewController *)self.parentViewController;
    if (vm)
    {
        if ([vc respondsToSelector:@selector(removeContactViewModel:)])
        {
            [vc removeContactViewModel:vm];
            [self toggleSelectedStateForCellAtIndexPath:indexPath];
        }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([((ViewController *)self.parentViewController).selectedContacts count] == CONTACTS_SELECTION_LIMIT)
    {
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ContactTableCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewController *vc;
    if ([self.parentViewController isKindOfClass:[ViewController class]])
    {
        vc = (ViewController *)self.parentViewController;
    }
    else
    {
        vc = ((ContactSearchController *)self.parentViewController).mainVC;
    }
    NITableViewModel *model = self.search.isActive ? self.searchModel : self.model;
    ContactTableCellViewModel *vm = [model objectAtIndexPath:indexPath];
    NSUInteger idx = [vc.selectedContacts indexOfObjectPassingTest:
                      ^BOOL(ContactTableCellViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        return obj.identifier == vm.identifier;
    }];
    if (idx != NSNotFound)
    {
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    cell.accessoryType = idx != NSNotFound ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

#pragma mark - UISearchControllerDelegate Protocol

- (void)didDismissSearchController:(UISearchController *)searchController
{
    self.tableView.dataSource = self.model;
    [self.tableView reloadData];
}

#pragma mark - UISearchResultsUpdating Protocol

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    [self.presenter filteredContactsByText:searchText];
}

#pragma mark - Presenter Protocol

- (void)willFetchData
{
    [self.indicator startAnimating];
}

- (void)didFetchData:(NSArray *)data
           withError:(NSError *)error
{
    if (self.search.isActive)
    {
        self.searchModel = [[NITableViewModel alloc] initWithSectionedArray:data delegate:self];
        [self setupViewModel:self.searchModel withSearch:NO withSummary:NO];
    }
    else
    {
        self.model = [[NITableViewModel alloc] initWithSectionedArray:data delegate:self];
        [self setupViewModel:self.model withSearch:NO withSummary:NO];
    }
    [self.indicator stopAnimating];
}

#pragma mark - NITableViewModelDelegate Protocol

- (ContactTableCell *)tableViewModel:(NITableViewModel *)tableViewModel
                   cellForTableView:(UITableView *)tableView
                        atIndexPath:(NSIndexPath *)indexPath
                         withObject:(ContactTableCellViewModel *)object
{
    ContactTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TABLE_CELL_REUSE_ID
                                                                  forIndexPath:indexPath];
    [cell updateWithViewModel:object];
    if (object.isImageDataAvailable)
    {
        [self.presenter fetchImageForContactWithIdentifier:object.identifier callback:^(NSData * _Nullable imageData, NSError * _Nullable error)
        {
            if (!error)
            {
                ContactTableCell *updatedCell = [self.tableView cellForRowAtIndexPath:indexPath];
                if (updatedCell)
                {
                    [updatedCell updateAvatarWithImageData:imageData];
                }
            }
        }];
    }
    else
    {
        [cell setInitialsBgColorForIndexPath:indexPath];
    }
    return cell;
}

@end
