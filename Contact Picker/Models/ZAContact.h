//
//  ZAContact.h
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#ifndef ZAContact_h
#define ZAContact_h

#import <Contacts/Contacts.h>

@interface ZAContact : NSObject

@property (readonly) NSString *identifier;
@property NSString *firstName;
@property NSString *lastName;
@property NSArray *phoneNumbers;
@property (readonly) BOOL hasImageData;

- (NSString *)fullName;
+ (instancetype)contactWithCNContact:(CNContact *)contact;

@end

#endif /* ZAContact_h */
