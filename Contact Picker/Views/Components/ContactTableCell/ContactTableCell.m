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
#import "ColorConstants.h"

@interface ContactTableCell ()

@property NSString *identifier;
@property NSString *initials;

@property (weak, nonatomic) IBOutlet UILabel *initialsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;

@end

@implementation ContactTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _identifier = [[NSString alloc] init];
        _initials = [[NSString alloc] init];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.initialsLabel.layer.masksToBounds = YES;
    self.initialsLabel.layer.cornerRadius = self.initialsLabel.frame.size.width / 2.0;
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2.0;
    self.initialsLabel.textColor = [UIColor whiteColor];
}

- (void)updateWithViewModel:(ContactTableCellViewModel *)viewModel
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.fullNameLabel.text = viewModel.fullName;
    self.initials = [self makeInitialsFromName:viewModel.fullName];
    self.initialsLabel.text = self.initials;
    self.avatar.image = [UIImage imageNamed:@"ContactAvatarPlaceholder"];
}

- (NSString *)makeInitialsFromName:(NSString *)name
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSArray<NSString *> *splitName = [name componentsSeparatedByString:@" "];
    [splitName enumerateObjectsUsingBlock:^(NSString * _Nonnull str, NSUInteger idx, BOOL * _Nonnull stop) {
        [result appendString:[NSString stringWithFormat:@"%C", [str characterAtIndex:0]]];
    }];
    return result;
}

- (void)setInitialsBgColorForIndexPath:(NSIndexPath *)indexPath
{
    NSArray *colors = [ColorConstants colorArray];
    NSUInteger colorIdx = (indexPath.row + indexPath.section) % [colors count];
    self.initialsLabel.backgroundColor = colors[colorIdx];
}

- (void)toggleSelect
{
    BOOL isSelected = self.isSelected;
    if (isSelected)
    {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
