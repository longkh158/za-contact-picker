//
//  ContactPickerCell.m
//  Contact Picker
//
//  Created by CPU12202 on 3/24/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactPickerCell.h"
#import "VMHelper.h"

@interface ContactPickerCell ()

@property NSString *identifier;
@property id <ContactPickerCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *initialsLabel;

@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@end

@implementation ContactPickerCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.initialsLabel.layer.masksToBounds = YES;
    self.initialsLabel.layer.cornerRadius = self.initialsLabel.frame.size.width / 2.0;
    self.initialsLabel.textColor = [UIColor whiteColor];
    [self.removeButton addTarget:self
                          action:@selector(onRemoveSelected:)
                forControlEvents:UIControlEventTouchDown];
}

- (void)attachDelegate:(id <ContactPickerCellDelegate>)delegate
{
    if ([delegate conformsToProtocol:@protocol(ContactPickerCellDelegate)])
    {
        self.delegate = delegate;
    }
}

- (void)updateWithViewModel:(ContactTableCellViewModel * _Nonnull)viewModel
{
    if (viewModel)
    {
        self.identifier = viewModel.identifier;
        self.initialsLabel.text = VMMakeInitialsFromName(viewModel.fullName);
        self.initialsLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
}

- (void)setInitialsBgColorForIndexPath:(NSIndexPath *)indexPath
{
    UIColor *random = VMBGColorForIndexPath(indexPath);
    self.initialsLabel.backgroundColor = random;
}

- (void)onRemoveSelected:(UIButton *)sender
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(handleRemoveSelectedContactWithIdentifier:)] &&
            self.identifier)
        {
            [self.delegate handleRemoveSelectedContactWithIdentifier:self.identifier];
        }
    }
}

@end
