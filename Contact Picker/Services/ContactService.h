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

typedef void (^CompletionHandler)(NSDictionary<NSString *, NSArray<ZAContact *> *> *contacts, NSError *err);

@interface ContactService : NSObject <ZASingleton>

- (void)fetchContactsWithCompletion:(CompletionHandler)completion;

@end

#endif /* ContactService_h */
