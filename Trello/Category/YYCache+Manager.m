//
//  YYCache+Manager.m
//  
//
//  Created by wxl on 16/3/7.
//  Copyright © 2016年 jensen. All rights reserved.
//

#import "YYCache+Manager.h"

static YYCache *cache;

@implementation YYCache (Manager)
+ (YYCache *)sharedCache {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
//        cache = [[YYCache alloc] initWithName:[[LLBSingleton sharedSingleton].loginUser.uid stringValue]];
        PowerLog(cache);
    });
    return cache;
}

+ (void)createCacheWithUid:(NSString *)uid{
    cache = [[YYCache alloc] initWithName:uid];
}

- (BOOL)containsCacheForApi:(YTKBaseRequest *)api {
    return [cache containsObjectForKey:api.cacheKey];
}

- (id)cacheForApi:(YTKBaseRequest *)api {
    return [cache objectForKey:api.cacheKey];
}

- (void)updateCache:(BaseModel *)model forApi:(YTKBaseRequest *)api {
    [cache setObject:[model mj_JSONString] forKey:api.cacheKey];
}

//- (void)updateCache:(BaseModel *)model forApiClassName:(NSString *)apiName {
//    [cache setObject:[model mj_keyValues] forKey:apiName];
//}

@end
