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
#import "NSMutableArray+QueueAdditions.h"

@interface ContactDataAdapter () <DataAdapter>

@property dispatch_queue_t internalQueue;
@property CNContactStore *store;
@property NSArray *keysToFetch;
@property (readonly, nonatomic) NSArray *allowedKeys;
@property NSDictionary<ContactDataKey, id <CNKeyDescriptor>> *keyMapping;
@property NSDictionary<NSString *, NSArray<ZAContact *> *> *contacts;
@property (getter=isFetching) BOOL fetching;
@property NSMutableArray<FetchDataCallback> *cbQueue;

- (NSDictionary *)sortedContactsDict:(NSArray<CNContact *> *)contacts;
- (NSArray *)filteredKeysToFetch:(NSArray *)keysToFetch;
- (void)executeCbQueueWithResult:(NSDictionary * _Nullable)result withError:(NSError * _Nullable)error;

@end

@implementation ContactDataAdapter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _fetching = NO;
        _cbQueue = [NSMutableArray array];
        _internalQueue = dispatch_queue_create("ContactDataAdapterQueue", DISPATCH_QUEUE_SERIAL);
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

- (NSArray *)filteredKeysToFetch:(NSArray *)keysToFetch;
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[keysToFetch count]];
    [keysToFetch enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
    {
        if ([self.allowedKeys containsObject:key])
        {
            [result addObject:key];
        }
    }];
    return result;
}

/*!
 Fetch contacts, optionally with a specified set of keys, and a queue to execute the task on.
 \param keysToFetch a set of keys to fetch. Specify \c nil to get all keys.
 \param queue a custom queue to execute the task on.
 \param callback a \c FetchDataCallback block called when finished fetching contacts.
 */
- (void)fetchContactsWithKeys:(NSArray * _Nullable)keysToFetch
                   usingQueue:(dispatch_queue_t _Nullable)queue
                     callback:(FetchDataCallback _Nonnull)callback
{
    if (callback)
    {
        NSArray *keys = [NSArray arrayWithArray:self.allowedKeys];
        if (keysToFetch)
        {
            keys = [self filteredKeysToFetch:keysToFetch];
        }
        self.keysToFetch = keys;
        [self fetchDataUsingQueue:queue withCallback:callback];
    }
}

#pragma mark - DataAdapter Protocol

- (void)fetchDataUsingQueue:(dispatch_queue_t _Nullable)queue withCallback:(FetchDataCallback _Nonnull)callback
{
    NSAssert(callback != nil, @"expect a non-null callback");
    NSMutableArray<CNContact *> __block *contacts = [[NSMutableArray alloc] init];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:self.keysToFetch];
    NSError __block *fetchError;
    if (callback)
    {
        if (self.isFetching)
        {
            dispatch_async(self.internalQueue, ^
            {
                [self.cbQueue addObject:callback];
            });
            return;
        }
        dispatch_queue_t queueToExecute = queue ? queue : self.internalQueue;
        [self setFetching:YES];
        dispatch_async(queueToExecute, ^
        {
            [self.cbQueue addObject:callback];
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
                if ([contacts count] == 0)
                {
                    NSDictionary *details = @{
                        NSLocalizedFailureReasonErrorKey: @"fetch contacts empty",
                    };
                    NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:FETCH_EMPTY userInfo:details];
                    [self executeCbQueueWithResult:nil withError:error];
                }
                else
                {
                    [self executeCbQueueWithResult:self.contacts withError:nil];
                }
            }
            else
            {
                NSDictionary *details = @{
                    NSLocalizedFailureReasonErrorKey: @"fetch contacts error",
                };
                NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:FETCH_ERROR userInfo:details];
                [self executeCbQueueWithResult:nil withError:error];
            }
        });
    }
}

- (void)filteredContactsWithPredicate:(NSPredicate *)predicate
                           usingQueue:(dispatch_queue_t)queue
                             callback:(FetchDataCallback)callback
{
    NSAssert(callback != nil, @"expect a non-null callback");
    if (callback)
    {
        if (!self.contacts)
        {
            [self fetchDataUsingQueue:queue
                         withCallback:callback];
        }
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[self.contacts count]];
        [self.contacts enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray<ZAContact *> * _Nonnull contactsWithKey, BOOL * _Nonnull stop)
        {
            NSArray *filteredContactsWithKey = [contactsWithKey filteredArrayUsingPredicate:predicate];
            if ([filteredContactsWithKey count] > 0)
            {
                [result setObject:filteredContactsWithKey forKey:key];
            }
        }];
        callback(result, nil);
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

- (void)executeCbQueueWithResult:(NSDictionary *)result
                       withError:(NSError *)error
{
    [self setFetching:NO];
    [self.cbQueue enumerateObjectsWithOptions:NSEnumerationConcurrent
                                   usingBlock:^(FetchDataCallback  _Nonnull cb, NSUInteger idx, BOOL * _Nonnull stop) {
        cb(result, error);
    }];
    [self.cbQueue removeAllObjects];
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
