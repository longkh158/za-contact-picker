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
#import "ContactTableViewController.h"
#import "ContactTableViewPresenter.h"
#import "ContactTableCell.h"
#import "AppConstants.h"

@interface ContactTableViewController () <UITableViewDelegate, NITableViewModelDelegate, ContactTableViewPresenterProtocol>

@property ContactTableViewPresenter *presenter;
@property NITableViewModel *viewModel;
@property NSArray<NSString *> *contactKeys;

@end

@implementation ContactTableViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableView.allowsMultipleSelection = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    [self.tableView registerClass:[ContactTableCell class] forCellReuseIdentifier:TABLE_CELL_REUSE_ID];
    [self.presenter attachView:self];
    [self.presenter getAllContacts];
}

#pragma mark - Initializers

- (void)setupView
{
    self.presenter = [[ContactTableViewPresenter alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionIndexColor = [UIColor systemGrayColor];
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

#pragma mark - Presenter Protocol

- (void)didFetchData:(NSArray *)data
           withError:(NSError *)error
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
