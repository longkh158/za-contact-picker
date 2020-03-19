//
//  NSDictionary+SortedDictionary.m
//  Contact Picker
//
//  Created by CPU12202 on 3/19/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import "NSDictionary+SortedDictionary.h"

@implementation NSDictionary (SortedDictionary)

- (NSArray *)sortedKeys
{
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

@end
