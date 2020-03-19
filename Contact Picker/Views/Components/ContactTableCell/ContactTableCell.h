//
//  ContactTableCell.h
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#ifndef ContactTableCell_h
#define ContactTableCell_h

#import <UIKit/UIKit.h>
#import "ContactTableCellViewModel.h"
#import "ColorConstants.h"

@interface ContactTableCell : UITableViewCell

@property (readonly) NSString *identifier;

- (instancetype)init;
- (void)updateWithViewModel:(ContactTableCellViewModel *)viewModel;

@end

#endif /* ContactTableCell_h */
