//
//  ZASingleton.h
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#ifndef ZASingleton_h
#define ZASingleton_h

NS_ASSUME_NONNULL_BEGIN

@protocol ZASingleton <NSObject>

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END

#endif /* ZASingleton_h */
