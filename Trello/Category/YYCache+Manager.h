//
//  YYCache+Manager.h
//  
//
//  Created by wxl on 16/3/7.
//  Copyright © 2016年 jensen. All rights reserved.
//

#import <YYCache/YYCache.h>
#import "BaseModel.h"
#import "BaseApi.h"

@interface YYCache (Manager)

+ (YYCache *)sharedCache;

+ (void)createCacheWithUid:(NSString *)uid;

- (BOOL)containsCacheForApi:(YTKBaseRequest *)api;

- (id)cacheForApi:(YTKBaseRequest *)api;

- (void)updateCache:(BaseModel *)model forApi:(YTKBaseRequest *)api;

//- (void)updateCache:(BaseModel *)model forApiClassName:(NSString *)apiName;

@end
