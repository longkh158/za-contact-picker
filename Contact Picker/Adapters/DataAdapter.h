//
//  DataAdapter.h
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^FetchDataCallback)(NSError  *_Nullable err);

@protocol DataAdapter <NSObject>

- (void)fetchDataWithCallback:(FetchDataCallback)callback;

@end

NS_ASSUME_NONNULL_END
