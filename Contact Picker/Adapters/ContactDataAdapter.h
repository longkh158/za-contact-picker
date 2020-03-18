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

NS_ASSUME_NONNULL_BEGIN

typedef enum ContactDataAuthorizationStatus : NSInteger
{
    ContactDataAuthorizationStatusNotDetermined = 0,
    ContactDataAuthorizationStatusRestricted,
    ContactDataAuthorizationStatusDenied,
    ContactDataAuthorizationStatusAuthorized,
}
ContactDataAuthorizationStatus;

typedef void (^RequestAccessCompletionHandler)(BOOL granted, NSError * _Nullable error);

@interface ContactDataAdapter : NSObject <ZASingleton, DataAdapter>

@property NSArray *keysToFetch;
@property (readonly) NSDictionary<NSString *, NSArray<ZAContact *> *> *contacts;

- (instancetype)init;
- (void)requestContactDataAccessWithCompetionHandler:(RequestAccessCompletionHandler)completionHandler;
+ (ContactDataAuthorizationStatus)contactDataAuthorizationStatus;

@end

NS_ASSUME_NONNULL_END

#endif /* ContactDataAdapter_h */
