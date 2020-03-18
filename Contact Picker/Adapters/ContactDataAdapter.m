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
#import "AppConstants.h"

@interface ContactDataAdapter ()

@property dispatch_semaphore_t semaphore;
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
        _semaphore = dispatch_semaphore_create(MAXIMUM_CALLBACKS_ALLOWED);
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

- (void)fetchDataUsingQueue:(dispatch_queue_t _Nullable)queue withCallback:(FetchDataCallback _Nonnull)callback
{
    NSAssert(callback != nil, @"expect a non-null callback");
    NSMutableArray<CNContact *> __block *contacts = [[NSMutableArray alloc] init];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:[self filteredKeysToFetch]];
    NSError __block *fetchError;
    if (callback)
    {
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        if (self.contacts)
        {
            callback(self.contacts, nil);
        }
        else
        {
            dispatch_queue_t queueToExecute = queue ? queue : dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
            dispatch_async(queueToExecute, ^
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
                    dispatch_semaphore_signal(self.semaphore);
                    callback(self.contacts, nil);
                }
                else
                {
                    NSDictionary *details = @{
                        NSLocalizedFailureReasonErrorKey: @"fetch contacts error",
                    };
                    NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:500 userInfo:details];
                    dispatch_semaphore_signal(self.semaphore);
                    callback(nil, error);
                }
            });
        }
    }
}

- (void)saveToContacts:(NSArray<CNContact *> *)contacts
{
    self.contacts = [self sortedContactsDict:contacts];
}

- (void)requestContactDataAccessWithCompetionHandler:(RequestAccessCompletionHandler)completionHandler
{
    [self.store requestAccessForEntityType:CNEntityTypeContacts completionHandler:completionHandler];
}

- (NSDictionary *)sortedContactsDict:(NSArray<CNContact *> *)contacts
{
    NSComparator contactSortOrder = [CNContact comparatorForNameSortOrder:CNContactSortOrderUserDefault];
    NSArray *sortedContacts = [contacts sortedArrayUsingComparator:contactSortOrder];
    NSCharacterSet __block *charSet = [NSCharacterSet letterCharacterSet];
    NSMutableDictionary<NSString *, NSMutableArray *> __block *result = [NSMutableDictionary dictionary];
    [sortedContacts enumerateObjectsUsingBlock:^(CNContact *_Nonnull cnContact, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [[NSString alloc] init];
        NSString *fullName = [CNContactFormatter stringFromContact:cnContact
                                                             style:CNContactFormatterStyleFullName];
        unichar firstLetter = [fullName characterAtIndex:0];
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

+ (ContactDataAuthorizationStatus)contactDataAuthorizationStatus
{
    switch ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts])
    {
        case CNAuthorizationStatusDenied:
            return ContactDataAuthorizationStatusDenied;
        case CNAuthorizationStatusRestricted:
            return ContactDataAuthorizationStatusRestricted;
        case CNAuthorizationStatusAuthorized:
            return ContactDataAuthorizationStatusAuthorized;
        case CNAuthorizationStatusNotDetermined:
            return ContactDataAuthorizationStatusNotDetermined;
    }
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
