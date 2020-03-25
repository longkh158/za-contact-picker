//
//  NSError+ErrorWithCodeAndMessage.m
//  Contact Picker
//
//  Created by CPU12202 on 3/25/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import "NSError+ErrorWithCodeAndMessage.h"

@implementation NSError (ErrorWithCodeAndMessage)

+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message className:(nonnull Class)class
{
    NSDictionary *details = @{
        NSLocalizedFailureReasonErrorKey: message,
    };
    return [NSError errorWithDomain:NSStringFromClass(class) code:code userInfo:details];
}

@end
