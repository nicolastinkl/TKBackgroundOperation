//
//  EGOCache.h
//  laixin
//
//  Created by apple on 14-1-24.
//  Copyright (c) 2014年 jijia. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@interface EGOCache : NSObject

+ (instancetype)currentCache __deprecated; // Renamed to globalCache

// Global cache for easy use
+ (instancetype)globalCache;

// Opitionally create a different EGOCache instance with it's own cache directory
- (id)initWithCacheDirectory:(NSString*)cacheDirectory;

- (void)clearCache;
- (void)removeCacheForKey:(NSString*)key;

- (BOOL)hasCacheForKey:(NSString*)key;

- (NSData*)dataForKey:(NSString*)key;
- (void)setData:(NSData*)data forKey:(NSString*)key;
- (void)setData:(NSData*)data forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

- (NSString*)stringForKey:(NSString*)key;
- (void)setString:(NSString*)aString forKey:(NSString*)key;
- (void)setString:(NSString*)aString forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

#if TARGET_OS_IPHONE
- (UIImage*)imageForKey:(NSString*)key;
- (void)setImage:(UIImage*)anImage forKey:(NSString*)key;
- (void)setImage:(UIImage*)anImage forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;
#else
- (NSImage*)imageForKey:(NSString*)key;
- (void)setImage:(NSImage*)anImage forKey:(NSString*)key;
- (void)setImage:(NSImage*)anImage forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;
#endif

- (id)plistForKey:(NSString*)key;
- (void)setPlist:(id)plistObject forKey:(NSString*)key;
- (void)setPlist:(id)plistObject forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

- (void)copyFilePath:(NSString*)filePath asKey:(NSString*)key;
- (void)copyFilePath:(NSString*)filePath asKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

- (id<NSCoding>)objectForKey:(NSString*)key;
- (void)setObject:(id<NSCoding>)anObject forKey:(NSString*)key;
- (void)setObject:(id<NSCoding>)anObject forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

@property(nonatomic,assign) NSTimeInterval defaultTimeoutInterval; // Default is 1 day
@end
