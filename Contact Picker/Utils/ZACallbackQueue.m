//
//  ZACallbackQueue.m
//  Contact Picker
//
//  Created by CPU12202 on 3/18/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZACallbackQueue.h"

@interface ZACallbackQueue ()

@property NSMutableArray *internal_queue;
@property dispatch_semaphore_t queue_limit;

@end

@implementation ZACallbackQueue

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _internal_queue = [NSMutableArray arrayWithCapacity:5];
    }
    return self;
}

@end
