//
//  ContactPickerController.m
//  Contact Picker
//
//  Created by CPU12202 on 3/23/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppConstants.h"
#import "ViewController.h"
#import "ContactPickerController.h"
#import "ContactPickerCell.h"
#import "ContactTableCellViewModel.h"

@interface ContactPickerController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ContactPickerCellDelegate>

@property NSMutableArray<ContactTableCellViewModel *> *selected;

@end

@implementation ContactPickerController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selected = [NSMutableArray arrayWithCapacity:CONTACTS_SELECTION_LIMIT];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ContactPickerCell" bundle:nil]
          forCellWithReuseIdentifier:COLLECTION_CELL_REUSE_ID];
}

- (void)attachViewModel:(NSMutableArray *)vm
{
    if ([vm isKindOfClass:[NSArray class]])
    {
        self.selected = vm;
    }
}

- (void)refreshUI
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.collectionView reloadSections:indexSet];
}

- (void)handleRemoveSelectedContactWithIdentifier:(NSString *)identifier
{
    if (self.parent && identifier)
    {
        NSUInteger idx = [self.selected indexOfObjectPassingTest:^BOOL(ContactTableCellViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            return [obj.identifier isEqualToString:identifier];
        }];
        if (idx != NSNotFound)
        {
            [self.parent removeContactViewModel:self.selected[idx]];
        }
    }
}

#pragma mark - UICollectionViewDataSource Protocol

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.selected)
    {
        return [self.selected count];
    }
    return 0;
}

- (ContactPickerCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selected)
    {
        ContactTableCellViewModel *vm = self.selected[indexPath.row];
        ContactPickerCell *cell = [self.collectionView
                                   dequeueReusableCellWithReuseIdentifier:COLLECTION_CELL_REUSE_ID
                                                             forIndexPath:indexPath];
        [cell updateWithViewModel:vm];
        [cell setInitialsBgColorForIndexPath:indexPath];
        [cell attachDelegate:self];
        return cell;
    }
    return nil;
}

@end
