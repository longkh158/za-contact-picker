//
//  ZAContact.m
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import "ZAContact.h"

@interface ZAContact ()

@property NSString *identifier;
@property NSString *fullName;
@property BOOL hasImageData;

@end

@implementation ZAContact

- (instancetype)initWithCNContact:(CNContact *)contact
{
    self = [super init];
    if (self)
    {
        _identifier = contact.identifier;
        _firstName = contact.givenName;
        _lastName = contact.familyName;
        _phoneNumbers = contact.phoneNumbers;
        _fullName = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
        _hasImageData = contact.imageDataAvailable;
    }
    return self;
}

+ (instancetype)contactWithCNContact:(CNContact *)contact
{
    return [[ZAContact alloc] initWithCNContact:contact];
}

@end
