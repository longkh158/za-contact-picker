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

- (void)setupBackground;

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
    [self setupBackground];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ContactPickerCell" bundle:nil]
          forCellWithReuseIdentifier:COLLECTION_CELL_REUSE_ID];
}

- (void)setupBackground
{
    self.collectionView.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterial];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    blurEffectView.frame = self.collectionView.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundView = blurEffectView;
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
    [self.collectionView reloadData];
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
        ContactTableCellViewModel *vm = self.selected[indexPath.section];
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
