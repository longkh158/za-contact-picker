//
//  ContactTableCell.m
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConstants.h"
#import "ContactTableCell.h"
#import "ContactTableCellViewModel.h"

@interface ContactTableCell ()

@property NSString *identifier;
@property NSString *initials;

@end

@implementation ContactTableCell

- (instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TABLE_CELL_REUSE_ID];
    if (self)
    {
        _identifier = [[NSString alloc] init];
        _initials = [[NSString alloc] init];
    }
    return self;
}

- (void)updateWithViewModel:(ContactTableCellViewModel *)viewModel
{
    self.textLabel.text = viewModel.fullName;
    self.imageView.image = nil;
}

@end
