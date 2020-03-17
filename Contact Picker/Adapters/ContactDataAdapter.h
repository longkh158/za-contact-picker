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

@interface ContactDataAdapter : NSObject <ZASingleton, DataAdapter>

@property NSArray *keysToFetch;
@property (readonly) NSDictionary<NSString *, NSArray<ZAContact *> *> *contacts;

- (instancetype)init;

@end

#endif /* ContactDataAdapter_h */
