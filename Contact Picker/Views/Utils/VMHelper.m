//
//  VMHelper.m
//  Contact Picker
//
//  Created by CPU12202 on 3/24/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VMHelper.h"
#import "ColorConstants.h"

NSString * VMMakeInitialsFromName(NSString *name)
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSArray<NSString *> *splitName = [name componentsSeparatedByString:@" "];
    [splitName enumerateObjectsUsingBlock:^(NSString * _Nonnull str, NSUInteger idx, BOOL * _Nonnull stop)
    {
        [result appendString:[NSString stringWithFormat:@"%C", [str characterAtIndex:0]]];
    }];
    return result;
}

UIColor * VMBGColorForIndexPath(NSIndexPath *indexPath)
{
    NSArray *colors = [ColorConstants colorArray];
    NSUInteger colorIdx = (indexPath.row + indexPath.section) % [colors count];
    return colors[colorIdx];
}
