//
//  ContactDataAdapter.m
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import "ContactDataAdapter.h"
#import "ZAContact.h"

@interface ContactDataAdapter ()

@property dispatch_queue_t queue;
@property CNContactStore *store;
@property (readonly, nonatomic) NSArray *allowedKeys;
@property NSDictionary<NSString *, NSArray<ZAContact *> *> *contacts;

- (NSDictionary *)sortedContactsDict:(NSArray<CNContact *> *)contacts;

@end

@implementation ContactDataAdapter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _queue = dispatch_queue_create("contact_data_adapter_queue", DISPATCH_QUEUE_CONCURRENT);
        _store = [[CNContactStore alloc] init];
        _allowedKeys = @[
            CNContactIdentifierKey,
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey,
            [CNContact descriptorForAllComparatorKeys],
            [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],
        ];
        _keysToFetch = _allowedKeys;
    }
    return self;
}

- (NSArray *)filteredKeysToFetch
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[self.keysToFetch count]];
    [self.keysToFetch enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
    {
        if ([self.allowedKeys containsObject:key])
        {
            [result addObject:key];
        }
    }];
    return result;
}

#pragma mark - DataAdapter Protocol

- (void)fetchDataWithCallback:(FetchDataCallback)callback
{
    NSMutableArray<CNContact *> __block *contacts = [[NSMutableArray alloc] init];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:[self filteredKeysToFetch]];
    NSError __block *fetchError;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
    {
        [self.store enumerateContactsWithFetchRequest:request error:&fetchError usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop)
        {
            NSAssert(fetchError == nil, @"fetch contacts error: %@", fetchError);
            if (fetchError)
            {
                *stop = YES;
            }
            else
            {
                [contacts addObject:contact];
            }
        }];
        if (!fetchError)
        {
            [self saveToContacts:contacts];
            callback(nil);
        }
        else
        {
            NSDictionary *details = @{
                NSLocalizedFailureReasonErrorKey: @"fetch contacts error",
            };
            NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:500 userInfo:details];
            callback(error);
        }
    });
}

- (void)saveToContacts:(NSArray<CNContact *> *)contacts
{
    self.contacts = [self sortedContactsDict:contacts];
}

- (NSDictionary *)sortedContactsDict:(NSArray<CNContact *> *)contacts
{
    NSArray *sortedContacts = [contacts sortedArrayUsingComparator:[CNContact comparatorForNameSortOrder:CNContactSortOrderUserDefault]];
    NSMutableDictionary<NSString *, NSMutableArray *> __block *result = [NSMutableDictionary dictionary];
    NSCharacterSet __block *charSet = [NSCharacterSet letterCharacterSet];
    [sortedContacts enumerateObjectsUsingBlock:^(CNContact *_Nonnull cnContact, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [[NSString alloc] init];
        unichar firstLetter = [[CNContactFormatter stringFromContact:cnContact
                                         style:CNContactFormatterStyleFullName] characterAtIndex:0];
        if ([charSet characterIsMember:firstLetter])
        {
            key = [[[NSString alloc] initWithCharacters:&firstLetter length:1] uppercaseString];
        }
        else
        {
            key = @"#";
        }
        if (!result[key])
        {
            [result setValue:[NSMutableArray new] forKey:key];
        }
        ZAContact *contact = [ZAContact contactWithCNContact:cnContact];
        [result[key] addObject:contact];
    }];
    return result;
}

+ (instancetype)sharedInstance
{
    static ContactDataAdapter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ContactDataAdapter alloc] init];
    });
    return instance;
}

@end
