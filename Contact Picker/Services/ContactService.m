//
//  ContactService.m
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactService.h"

@interface ContactService ()

@end

@implementation ContactService

- (void)fetchContactsWithCompletion:(CompletionHandler _Nonnull)completion
{
    NSAssert(completion != nil, @"nil given to completion handler");
    // presenter will pop the block out of the stack when it returns, so we must keep a strong pointer
    __strong __block CompletionHandler _completion = completion;
    if (_completion)
    {
        switch ([ContactDataAdapter contactDataAuthorizationStatus])
        {
            case ContactDataAuthorizationStatusRestricted:
                /* fallthrough */
            case ContactDataAuthorizationStatusDenied:
            {
                NSDictionary *details = @{
                    NSLocalizedFailureReasonErrorKey: @"No permission to access contacts data",
                };
                NSError *error = [[NSError alloc] initWithDomain:NSStringFromClass([self class])
                                                            code:FETCH_UNAUTHORIZED
                                                        userInfo:details];
                _completion(nil, error);
                break;
            }
            case ContactDataAuthorizationStatusAuthorized:
                [[ContactDataAdapter sharedInstance] fetchContactsWithKeys:nil
                                                                usingQueue:nil
                                                                  callback:^(NSDictionary *contacts, NSError *error)
                {
                    if (error)
                    {
                        _completion(nil, error);
                    }
                    else
                    {
                        _completion(contacts, nil);
                    }
                }];
                break;
            case ContactDataAuthorizationStatusNotDetermined:
                [[ContactDataAdapter sharedInstance] requestContactDataAccessWithCompetionHandler:^(BOOL granted, NSError * _Nullable error)
                {
                    if (!granted)
                    {
                        _completion(nil, error);
                    }
                    else
                    {
                        [self fetchContactsWithCompletion:_completion];
                    }
                }];
                break;
        }
    }
}

- (void)filteredContactsWithText:(NSString *)text completionHandler:(CompletionHandler)completion
{
    NSAssert(completion != nil, @"nil given to completion handler");
    if (completion)
    {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(ZAContact * _Nullable contact, NSDictionary<NSString *,id> * _Nullable bindings)
        {
            if ([text length] == 0)
            {
                return YES;
            }
            return [[contact fullName] localizedCaseInsensitiveContainsString:text];
        }];
        __strong __block CompletionHandler _completion = completion;
        [[ContactDataAdapter sharedInstance] filteredContactsWithPredicate:predicate
                                                                usingQueue:nil
                                                                  callback:^(NSDictionary<NSString *,NSArray *> * _Nullable filteredContacts, NSError * _Nullable err)
        {
            _completion(filteredContacts, nil);
        }];
    }
}

- (void)fetchImageDataOfContactWithIdentifier:(NSString * _Nonnull)identifier
                               withCompletion:(FetchImageDataCallback _Nonnull)completion
{
    NSAssert(completion != nil, @"nil given to completion handler");
    if (completion && identifier)
    {
        __strong __block FetchImageDataCallback _completion = completion;
        NSData * _Nullable imageData = [[ImageCacheService sharedInstance] imageDataForKey:identifier];
        if (!imageData)
        {
            [[ContactDataAdapter sharedInstance] imageDataForContactWithIdentifier:identifier
                                                                          callback:
             ^(NSData * _Nonnull imageData, NSError * _Nonnull error)
            {
                if (!error)
                {
                    [[ImageCacheService sharedInstance] setImageData:imageData withKey:identifier];
                    _completion(imageData, nil);
                }
                else
                {
                    _completion(nil, error);
                }
            }];
        }
        else
        {
            _completion(imageData, nil);
        }
    }
}

- (void)createContact:(ZAContact *)contact withCompletion:(CompletionHandler)completion
{
    
}

- (void)editContact:(ZAContact *)contact withCompletion:(CompletionHandler)completion
{
    
}

- (void)deleteContact:(ZAContact *)contact withCompletion:(CompletionHandler)completion
{
    
}

+ (instancetype)sharedInstance
{
    static ContactService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ContactService alloc] init];
    });
    return instance;
}

@end
