//
//  ContactDataAdapterConstants.m
//  Contact Picker
//
//  Created by CPU12202 on 3/24/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import "ContactDataAdapter.h"
#import "ContactDataAdapterConstants.h"

@implementation ContactDataAdapterConstants

+ (NSArray *)allowedKeys
{
    return @[
        CNContactIdentifierKey,
        CNContactGivenNameKey,
        CNContactFamilyNameKey,
        CNContactPhoneNumbersKey,
        CNContactImageDataKey,
        CNContactThumbnailImageDataKey,
    ];
}

+ (NSArray *)auxKeys
{
    return @[
        CNContactImageDataAvailableKey,
        [CNContact descriptorForAllComparatorKeys],
        [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],
    ];
}

+ (NSDictionary<NSString *,id> *)keyMappings
{
    return @{
        ContactDataKeyFirstName: CNContactGivenNameKey,
        ContactDataKeyLastName: CNContactFamilyNameKey,
        ContactDataKeyFullName: [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],
        ContactDataKeyPhoneNumbers: CNContactPhoneNumbersKey,
        ContactThumbnailImage: CNContactThumbnailImageDataKey,
    };
}

@end
