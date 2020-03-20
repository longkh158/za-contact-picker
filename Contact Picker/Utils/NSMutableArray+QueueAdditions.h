//
//  NSMutableArray+QueueAdditions.h
//  Contact Picker
//
//  Created by CPU12202 on 3/20/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (QueueAdditions)

- (id _Nullable)dequeue;
- (void)enqueue:(id)obj;

@end

NS_ASSUME_NONNULL_END
