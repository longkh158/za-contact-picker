//
//  ImageCacheService.h
//  Contact Picker
//
//  Created by CPU12202 on 3/18/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#ifndef ImageCacheService_h
#define ImageCacheService_h

#import "ZASingleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageCacheService : NSObject <ZASingleton>

- (instancetype)init;
- (void)setImageData:(NSData *)imageData withKey:(NSString *)key;
- (NSData * _Nullable)imageDataForKey:(NSString *)key;
- (void)purgeCache;

NS_ASSUME_NONNULL_END

@end

#endif /* ImageCacheService_h */
