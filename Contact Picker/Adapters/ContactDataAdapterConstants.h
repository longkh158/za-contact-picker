//
//  ContactDataAdapterConstants.h
//  Contact Picker
//
//  Created by CPU12202 on 3/23/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#ifndef ContactDataAdapterConstants_h
#define ContactDataAdapterConstants_h

static NSInteger FETCH_ERROR = 500;
static NSInteger FETCH_EMPTY = 404;
static NSInteger FETCH_UNAUTHORIZED = 401;

@interface ContactDataAdapterConstants : NSObject

+ (NSArray *)allowedKeys;
+ (NSArray *)auxKeys;
+ (NSDictionary<NSString *, id> *)keyMappings;

@end

#endif /* ContactDataAdapterConstants_h */