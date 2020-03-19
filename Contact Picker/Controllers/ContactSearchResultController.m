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
    [self.tableView registerClass:[ContactTableCell class] forCellReuseIdentifier:TABLE_CELL_REUSE_ID];
    [self.presenter attachView:self];
}

#pragma mark - UISearchResultsUpdating Protocol

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    NSLog(@"search text: %@", searchText);
}

#pragma mark - Presenter Protocol
- (void)didFetchData:(id)data withError:(NSError *)error
{
    
}

#pragma mark - NITableViewModelDelegate Protocol
- (UITableViewCell *)tableViewModel:(NITableViewModel *)tableViewModel
                   cellForTableView:(UITableView *)tableView
                        atIndexPath:(NSIndexPath *)indexPath
                         withObject:(ContactTableCellViewModel *)object
{
    return nil;
}

@end
