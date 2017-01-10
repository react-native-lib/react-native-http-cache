//
//  RCTHttpCache.m
//  RCTHttpCache
//
//  Created by LvBingru on 12/30/15.
//  Copyright © 2015 erica. All rights reserved.
//

#import "RCTHttpCache.h"
#import <React/RCTImageLoader.h>
#import <React/RCTBridge.h>

@implementation RCTHttpCache

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE(HttpCache);

RCT_EXPORT_METHOD(getHttpCacheSize:(RCTResponseSenderBlock)resolve)
{
    NSURLCache *httpCache = [NSURLCache sharedURLCache];
    resolve(@[[NSNull null], @([httpCache currentDiskUsage])]);
}

RCT_EXPORT_METHOD(clearCache:(RCTResponseSenderBlock)resolve)
{
    NSURLCache *httpCache = [NSURLCache sharedURLCache];
    [httpCache removeAllCachedResponses];
    resolve(@[[NSNull null]]);
}


RCT_EXPORT_METHOD(getImageCacheSize:(RCTResponseSenderBlock)resolve)
{
    NSCache *imageCache = [self imageCache];
    dispatch_queue_t queue = [self imageCacheQueue];
    if (imageCache == nil || queue == nil) {
        resolve(@[@"cache not found"]);
    }
    dispatch_async(queue, ^{
        resolve(@[[NSNull null], @(0)]);
    });
}

RCT_EXPORT_METHOD(clearImageCache:(RCTResponseSenderBlock)resolve)
{
    NSCache *imageCache = [self imageCache];
    dispatch_queue_t queue = [self imageCacheQueue];
 
    if (imageCache == nil || queue == nil) {
        resolve(@[@"cache not found"]);
    }

    dispatch_async(queue, ^{
        [imageCache removeAllObjects];
        resolve(@[[NSNull null]]);
    });
}

- (NSCache *)imageCache
{
    RCTImageLoader* loader = _bridge.imageLoader;
    NSURLCache *cache = [[loader valueForKey:@"_imageCache"] valueForKey:@"_decodedImageCache"];
    
    return cache;
}

- (dispatch_queue_t)imageCacheQueue
{
    RCTImageLoader* loader = _bridge.imageLoader;
    dispatch_queue_t queue = [loader valueForKey:@"_URLRequestQueue"];
    return queue;
}


@end
