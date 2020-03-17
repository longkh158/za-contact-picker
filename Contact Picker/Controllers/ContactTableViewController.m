//
//  ContactTableViewController.m
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppConstants.h"
#import "ContactTableViewController.h"
#import "ContactTableViewPresenter.h"
#import "ContactTableViewPresenterProtocol.h"
#import "ContactTableCell.h"
#import "ContactTableCellViewModel.h"

@interface ContactTableViewController () <UITableViewDelegate, UITableViewDataSource, ContactTableViewPresenterProtocol>

@property ContactTableViewPresenter *presenter;
@property NSDictionary<NSString *, NSArray<ContactTableCellViewModel *> *> *dataSource;
@property NSArray<NSString *> *contactKeys;

@end

@implementation ContactTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[ContactTableCell class] forCellReuseIdentifier:TABLE_CELL_REUSE_ID];
    [self initializePresenter];
    [self.presenter attachView:self];
    [self.presenter getAllContacts];
}

#pragma mark - Initializers

- (void)initializePresenter
{
    self.presenter = [[ContactTableViewPresenter alloc] init];
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.dataSource allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TABLE_CELL_REUSE_ID
                                                                  forIndexPath:indexPath];
    [cell updateWithViewModel:[self.dataSource objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Presenter Protocol

- (void)didFetchData:(id)data withError:(NSError *)error
{
    self.dataSource = data;
    [self.tableView reloadData];
}

@end
