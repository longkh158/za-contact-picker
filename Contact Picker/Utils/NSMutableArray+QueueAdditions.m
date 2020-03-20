//
//  NSMutableArray+QueueAdditions.m
//  Contact Picker
//
//  Created by CPU12202 on 3/20/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import "NSMutableArray+QueueAdditions.h"

@implementation NSMutableArray (QueueAdditions)

- (id _Nullable)dequeue
{
    if ([self count] == 0)
    {
        return nil;
    }
    else
    {
        id obj = [self objectAtIndex:0];
        [self removeObject:obj];
        return obj;
    }
}

- (void)enqueue:(id)obj
{
    if (obj)
    {
        [self addObject:obj];
    }
}

@end
