//
//  ContactPickerCell.h
//  Contact Picker
//
//  Created by CPU12202 on 3/24/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#ifndef ContactPickerCell_h
#define ContactPickerCell_h

#import <UIKit/UIKit.h>
#import "ContactTableCellViewModel.h"
#import "ContactPickerCellDelegate.h"

@interface ContactPickerCell : UICollectionViewCell

@property (readonly) NSString *identifier;

- (void)awakeFromNib;
- (void)attachDelegate:(id <ContactPickerCellDelegate>)delegate;
- (void)updateWithViewModel:(ContactTableCellViewModel *)viewModel;
- (void)setInitialsBgColorForIndexPath:(NSIndexPath *)indexPath;

@end

#endif /* ContactPickerCell_h */
