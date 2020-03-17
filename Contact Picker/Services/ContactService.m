//
//  ContactService.m
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactService.h"
#import "ContactDataAdapter.h"

@interface ContactService ()

@end

@implementation ContactService

- (void)fetchContactsWithCompletion:(CompletionHandler)completion
{
    [[ContactDataAdapter sharedInstance] fetchDataWithCallback:^(NSError *error)
    {
        if (error)
        {
            completion(nil, error);
        }
        else
        {
            completion([ContactDataAdapter sharedInstance].contacts, nil);
        }
    }];
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
