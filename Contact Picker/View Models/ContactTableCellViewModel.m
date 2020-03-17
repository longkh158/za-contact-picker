//
//  ContactTableCellViewModel.m
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactTableCellViewModel.h"
#import "ZAContact.h"

@interface ContactTableCellViewModel ()

@property NSString *identifier;
@property NSString *fullName;

@end

@implementation ContactTableCellViewModel

+ (instancetype)fromModel:(ZAContact *)model
{
    ContactTableCellViewModel *viewModel = [[ContactTableCellViewModel alloc] init];
    viewModel.identifier = model.identifier;
    viewModel.fullName = [model fullName];
    return viewModel;
}

@end
