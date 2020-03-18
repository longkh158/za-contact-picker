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
#import "AppConstants.h"
#import "ContactTableViewController.h"
#import "ContactTableViewPresenter.h"
#import "ContactTableViewPresenterProtocol.h"
#import "ContactTableCell.h"
#import "ContactTableCellViewModel.h"

@interface ContactTableViewController () <UITableViewDelegate, UITableViewDataSource, ContactTableViewPresenterProtocol, NITableViewModelDelegate>

@property ContactTableViewPresenter *presenter;
@property NITableViewModel *model;
@property NSDictionary<NSString *, NSArray<ContactTableCellViewModel *> *> *dataSource;
@property NSArray<NSString *> *contactKeys;

- (NSArray *)sortContactsKeys:(NSArray *)keys;

@end

@implementation ContactTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[ContactTableCell class] forCellReuseIdentifier:TABLE_CELL_REUSE_ID];
//    self.tableView.dataSource = self.viewModel;
    [self initialize];
    [self.presenter attachView:self];
    [self.presenter getAllContacts];
}

#pragma mark - Initializers

- (void)initialize
{
    self.contactKeys = [[NSArray alloc] init];
    self.presenter = [[ContactTableViewPresenter alloc] init];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_CELL_HEIGHT;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.contactKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSAssert(section < [self.contactKeys count], @"section number exceed total keys");
    NSString *key = [self.contactKeys objectAtIndex:section];
    NSArray *contactsWithKey = [self.dataSource objectForKey:key];
    return [contactsWithKey count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TABLE_CELL_REUSE_ID
                                                                  forIndexPath:indexPath];
    NSAssert(indexPath.section < [self.contactKeys count], @"section number exceed total keys");
    NSString *key = [self.contactKeys objectAtIndex:indexPath.section];
    NSArray *section = [self.dataSource objectForKey:key];
    NSAssert(section != nil, @"key expected to exist in data source. nil received");
    [cell updateWithViewModel:[section objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Presenter Protocol

- (void)didFetchData:(NSDictionary *)data withError:(NSError *)error
{
    self.dataSource = data;
    self.contactKeys = [self sortContactsKeys:[data allKeys]];
    self.model = [[NITableViewModel alloc] initWithDelegate:self];
    [self.tableView reloadData];
}

- (NSArray *)sortContactsKeys:(NSArray *)keys
{
    return [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (UITableViewCell *)tableViewModel:(NITableViewModel *)tableViewModel
                   cellForTableView:(UITableView *)tableView
                        atIndexPath:(NSIndexPath *)indexPath
                         withObject:(ContactTableCellViewModel *)object
{
    ContactTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TABLE_CELL_REUSE_ID
                                                                  forIndexPath:indexPath];
    NSAssert(indexPath.section < [self.contactKeys count], @"section number exceed total keys");
    NSString *key = [self.contactKeys objectAtIndex:indexPath.section];
    NSArray *section = [self.dataSource objectForKey:key];
    NSAssert(section != nil, @"key expected to exist in data source. nil received");
    [cell updateWithViewModel:[section objectAtIndex:indexPath.row]];
    return cell;
}

@end
