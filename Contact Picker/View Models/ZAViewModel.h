//
//  ZAViewModel.h
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZAViewModel <NSObject>

+ (instancetype)fromModel:(id _Nonnull)model;

@end

NS_ASSUME_NONNULL_END
