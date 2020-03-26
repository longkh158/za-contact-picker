//
//  ContactDataAdapter.h
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#ifndef ContactDataAdapter_h
#define ContactDataAdapter_h

#import "ZASingleton.h"
#import "DataAdapter.h"
#import "ZAContact.h"
#import "ContactDataAdapterConstants.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^RequestAccessCompletionHandler)(BOOL granted, NSError * _Nullable error);

@interface ContactDataAdapter : NSObject <ZASingleton>

@property (readonly) NSDictionary<NSString *, NSArray<ZAContact *> *> *contacts;

- (instancetype)init;
- (void)requestContactDataAccessWithCompetionHandler:(RequestAccessCompletionHandler)completionHandler;
- (void)fetchContactsWithKeys:(NSArray<ContactDataKey> * _Nullable)keysToFetch
                   usingQueue:(dispatch_queue_t _Nullable)queue
                     callback:(FetchDataCallback)callback;
- (void)filteredContactsWithPredicate:(NSPredicate *)predicate
                           usingQueue:(dispatch_queue_t _Nullable)queue
                             callback:(FetchDataCallback _Nullable)callback;
- (void)imageDataForContactWithIdentifier:(NSString *)identifier
                                 callback:(void (^)(NSData * imageData, NSError * error))callback;
- (void)contactWithIdentifier:(NSString *)identifier
                   usingQueue:(dispatch_queue_t _Nullable)queue
                     callback:(FetchDataCallback)callback;
- (void)createContact:(ZAContact *)contact
          keysToFetch:(NSArray<ContactDataKey> * _Nullable)keysToFetch
           usingQueue:(dispatch_queue_t _Nullable)queue
             callback:(FetchDataCallback _Nullable)callback;

+ (ContactDataAuthorizationStatus)contactDataAuthorizationStatus;

@end

NS_ASSUME_NONNULL_END

#endif /* ContactDataAdapter_h */
