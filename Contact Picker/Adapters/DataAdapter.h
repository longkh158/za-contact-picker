//
//  DataAdapter.h
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^FetchDataCallback)(NSDictionary<NSString *, NSArray *> * _Nullable data, NSError  * _Nullable err);

@protocol DataAdapter <NSObject>


/*!
 Fetch contacts data, optionally using a custom-defined queue.
 \param queue - The queue to execute the fetching task in. Specify \c nil to using a global queue.
 */
- (void)fetchDataUsingQueue:(dispatch_queue_t _Nullable)queue withCallback:(FetchDataCallback)callback;

@end

NS_ASSUME_NONNULL_END
