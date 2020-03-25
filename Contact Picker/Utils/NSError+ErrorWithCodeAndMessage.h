//
//  NSError+ErrorWithCodeAndMessage.h
//  Contact Picker
//
//  Created by CPU12202 on 3/25/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (ErrorWithCodeAndMessage)

+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message className:(Class)class;

@end

NS_ASSUME_NONNULL_END
