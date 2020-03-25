//
//  ContactService.h
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#ifndef ContactService_h
#define ContactService_h

#import "ZASingleton.h"
#import "ZAContact.h"
#import "ImageCacheService.h"
#import "ContactDataAdapter.h"

NS_ASSUME_NONNULL_BEGIN

/// A callback called when the underlying \c DataAdapter class has finished execution
typedef __weak void (^CompletionHandler)(NSDictionary<NSString *, NSArray<ZAContact *> *> * _Nullable contacts, NSError * _Nullable err);

typedef void (^FetchImageDataCallback)(NSData * _Nullable imageData, NSError * _Nullable error);

@interface ContactService : NSObject <ZASingleton>

- (void)fetchContactsWithCompletion:(CompletionHandler)completion;
- (void)filteredContactsWithText:(NSString *)text completionHandler:(CompletionHandler)completion;
- (void)fetchImageDataOfContactWithIdentifier:(NSString *)identifier
                               withCompletion:(FetchImageDataCallback)completion;
- (void)createContact:(ZAContact *)contact withCompletion:(CompletionHandler)completion;
- (void)editContact:(ZAContact *)contact withCompletion:(CompletionHandler)completion;
- (void)deleteContact:(ZAContact *)contact withCompletion:(CompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END

#endif /* ContactService_h */
