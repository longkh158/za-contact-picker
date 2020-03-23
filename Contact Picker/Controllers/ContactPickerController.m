//
//  ContactPickerController.m
//  Contact Picker
//
//  Created by CPU12202 on 3/23/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ContactPickerController.h"
#import "ContactTableCellViewModel.h"

@interface ContactPickerController () <UICollectionViewDataSource>

@property ViewController *parent;
@property NSArray<ContactTableCellViewModel *> *selected;

@end

@implementation ContactPickerController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        _selected = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.parent = (ViewController *)self.parentViewController;
}

- (void)attachViewModel:(NSMutableArray *)vm
{
    if ([vm isKindOfClass:[NSArray class]])
    {
        self.selected = vm;
    }
}

#pragma mark - UICollectionViewDataSource Protocol

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.selected count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableCellViewModel *vm = self.selected[indexPath.row];
    return nil;
}

@end
