//
//  ImageCacheService.m
//  Contact Picker
//
//  Created by CPU12202 on 3/18/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCacheService.h"
#import "AppConstants.h"

@interface ImageCacheService ()

@property NSCache<NSString *, NSData *> *cache;

@end

@implementation ImageCacheService

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = CACHE_LIMIT;
    }
    return self;
}

- (void)setImageData:(NSData * _Nonnull)imageData withKey:(NSString * _Nonnull)key
{
    if (imageData && key)
    {
        [self.cache setObject:imageData forKey:key];
    }
}

- (NSData * _Nullable)imageDataForKey:(NSString * _Nonnull)key
{
    return [self.cache objectForKey:key];
}

- (void)purgeCache
{
    [self.cache removeAllObjects];
}

+ (instancetype)sharedInstance
{
    static ImageCacheService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ImageCacheService alloc] init];
    });
    return instance;
}

@end
