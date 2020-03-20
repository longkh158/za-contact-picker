//
//  ContactTableViewPresenter.m
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactTableViewPresenter.h"
#import "ContactService.h"
#import "ContactTableCellViewModel.h"
#import "ZAContact.h"
#import "NSDictionary+SortedDictionary.h"

@interface ContactTableViewPresenter ()

@property (nonatomic, weak) id <ContactTableViewPresenterProtocol> delegate;
@property (nonnull) ContactService *service;

- (NSArray *)mapToVMSectionedArray:(NSDictionary<NSString *,NSArray<ZAContact *> *> *)contacts;

@end

@implementation ContactTableViewPresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _service = [[ContactService alloc] init];
    }
    return self;
}

- (void)attachView:(id<ContactTableViewPresenterProtocol>)view
{
    self.delegate = view;
}

- (void)getAllContacts
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(willFetchData)])
        {
            [self.delegate willFetchData];
        }
        [self.service fetchContactsWithCompletion:[self fetchContactCompletion]];
    }
}

- (void)filteredContactsByText:(NSString *)text
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(willFetchData)])
        {
            [self.delegate willFetchData];
        }
        [self.service filteredContactsWithText:text
                             completionHandler:[self fetchContactCompletion]];
    }
}

- (NSArray * _Nonnull)mapToVMSectionedArray:(NSDictionary<NSString *,NSArray<ZAContact *> *> * _Nonnull)contacts
{
    NSMutableArray *result = [NSMutableArray array];
    NSArray<NSString *> *sortedKeys = [contacts sortedKeys];
    [sortedKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop)
    {
        [result addObject:key];
        NSArray<ZAContact *> *contactsWithKey = contacts[key];
        [contactsWithKey enumerateObjectsUsingBlock:^(ZAContact * _Nonnull contact, NSUInteger idx, BOOL * _Nonnull stop)
        {
            ContactTableCellViewModel *vm = [ContactTableCellViewModel fromModel:contact];
            [result addObject:vm];
        }];
    }];
    return result;
}

- (CompletionHandler)fetchContactCompletion {
    return ^(NSDictionary<NSString *,NSArray<ZAContact *> *> * _Nullable contacts, NSError * _Nullable err)
    {
        if (err)
        {
            [self.delegate didFetchData:nil withError:err];
        }
        else if (contacts)
        {
            if ([contacts count] == 0)
            {
                if ([self.delegate respondsToSelector:@selector(didFetchEmpty)])
                {
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                        [self.delegate didFetchEmpty];
                    });
                }
            }
            else
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                               {
                    NSArray *vms = [self mapToVMSectionedArray:contacts];
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                        [self.delegate didFetchData:vms withError:nil];
                    });
                });
            }
        }
    };
}

@end
