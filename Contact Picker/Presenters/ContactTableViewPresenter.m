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

@interface ContactTableViewPresenter ()

@property id <ContactTableViewPresenterProtocol> delegate;

- (NSDictionary *)mapToViewModels:(NSDictionary<NSString *,NSArray<ZAContact *> *> *)contacts;

@end

@implementation ContactTableViewPresenter

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
        [[ContactService sharedInstance] fetchContactsWithCompletion:^(NSDictionary<NSString *,NSArray<ZAContact *> *> *contacts, NSError *err)
        {
            if (err)
            {
                [self.delegate didFetchData:nil withError:err];
            }
            else if ([contacts count] == 0)
            {
                if ([self.delegate respondsToSelector:@selector(didFetchEmpty)])
                {
                    [self.delegate didFetchEmpty];
                }
            }
            else
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                {
                    NSDictionary *vms = [self mapToViewModels:contacts];
                    dispatch_async(dispatch_get_main_queue(), ^
                    {
                        [self.delegate didFetchData:vms withError:nil];
                    });
                });
            }
        }];
    }
}

- (NSDictionary *)mapToViewModels:(NSDictionary<NSString *,NSArray<ZAContact *> *> *)contacts
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [contacts enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray<ZAContact *> * _Nonnull contactsWithKey, BOOL * _Nonnull stop)
    {
        if (!result[key])
        {
            result[key] = [NSMutableArray arrayWithCapacity:[contactsWithKey count]];
        }
        [contactsWithKey enumerateObjectsUsingBlock:^(ZAContact * _Nonnull contact, NSUInteger idx, BOOL * _Nonnull stop)
        {
            ContactTableCellViewModel *vm = [ContactTableCellViewModel fromModel:contact];
            [result[key] addObject:vm];
        }];
    }];
    return result;
}

@end
