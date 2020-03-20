//
//  ContactSearchResultController.m
//  Contact Picker
//
//  Created by CPU12202 on 3/19/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Nimbus/NITableViewModel.h>
#import "ContactTableCell.h"
#import "ContactSearchResultController.h"
#import "ContactTableViewPresenter.h"
#import "AppConstants.h"

@interface ContactSearchResultController () <UISearchResultsUpdating, NITableViewModelDelegate, ContactTableViewPresenterProtocol>

@property ContactTableViewPresenter *presenter;
@property NITableViewModel *viewModel;

@property UIActivityIndicatorView *indicator;

@end

@implementation ContactSearchResultController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _presenter = [[ContactTableViewPresenter alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    [self.tableView registerClass:[ContactTableCell class] forCellReuseIdentifier:TABLE_CELL_REUSE_ID];
    [self.presenter attachView:self];
}

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

- (void)setupViewModelWithSearch:(BOOL)showSearch
                     withSummary:(BOOL)showSummary
{
    self.tableView.dataSource = self.viewModel;
    [self.viewModel setSectionIndexType:NITableViewModelSectionIndexAlphabetical
                            showsSearch:showSearch
                           showsSummary:showSummary];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate Protocol

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UITableViewHeaderFooterView *)view forSection:(NSInteger)section
{
    view.contentView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UISearchResultsUpdating Protocol

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    [self.presenter filteredContactsByText:searchText];
}

#pragma mark - Presenter Protocol
- (void)didFetchData:(id)data withError:(NSError *)error
{
    self.viewModel = [[NITableViewModel alloc] initWithSectionedArray:data delegate:self];
    [self setupViewModelWithSearch:NO
                       withSummary:NO];
}

#pragma mark - NITableViewModelDelegate Protocol
- (UITableViewCell *)tableViewModel:(NITableViewModel *)tableViewModel
                   cellForTableView:(UITableView *)tableView
                        atIndexPath:(NSIndexPath *)indexPath
                         withObject:(ContactTableCellViewModel *)object
{
    ContactTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TABLE_CELL_REUSE_ID
                                                                  forIndexPath:indexPath];
    [cell updateWithViewModel:object];
    return cell;
}

@end
