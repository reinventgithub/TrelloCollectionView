//
//  YTKBaseRequest.m
//
//  Copyright (c) 2012-2014 YTKNetwork https://github.com/yuantiku
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "YTKBaseRequest.h"
#import "YTKNetworkAgent.h"
#import "YTKNetworkPrivate.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <MJExtension/MJExtension.h>
#import "YYCache+Manager.h"

@interface YTKBaseRequest ()
@property (strong, nonatomic, readwrite) NSString *cacheKey;
@end


@implementation YTKBaseRequest

/// for subclasses to overwrite
- (void)requestCompleteFilter {
}

- (void)requestFailedFilter {
}

- (NSString *)componentUrl {
    return @"";
}

- (NSString *)requestUrl {
    return @"";
}

- (NSString *)cdnUrl {
    return @"";
}

- (NSString *)baseUrl {
    return @"";
}

- (NSTimeInterval)requestTimeoutInterval {
    return 60;
}

- (id)requestArgument {
    unsigned int propCount;
    objc_property_t* properties = class_copyPropertyList([self class], &propCount);
    
    unsigned int superPropCount;
    objc_property_t* superProperties = class_copyPropertyList(NSClassFromString(@"BaseApi"), &superPropCount);
    
    unsigned int totalPropCount = propCount+superPropCount;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:totalPropCount];
    
    NSArray *onlyForSignParams;
    if ([self requestMethod] == YTKRequestMethodGet) {
        onlyForSignParams = [self onlyForSignArgumentForGet];
    }
    else {
        onlyForSignParams = [self onlyForSignArgument];
    }
    
    NSArray *ignoreParams = [self ignoreArgument];
    
    id kindOfClass = [self componentUrlAppendArgument];
    NSArray *appendParams;
    if (kindOfClass) {
        if ([kindOfClass isKindOfClass:[NSArray class]]) {
            appendParams = kindOfClass;
        }
        else {
            appendParams = @[kindOfClass];
        }
    }
    
    if (ignoreParams) {
        ignoreParams = [ignoreParams arrayByAddingObjectsFromArray:onlyForSignParams];
    }
    else {
        ignoreParams = onlyForSignParams;
    }
    
    if (appendParams) {
        ignoreParams = [ignoreParams arrayByAddingObjectsFromArray:appendParams];
    }
    
    NSDictionary *mappingPatamsDic = [self configArgument];
    PowerLog(mappingPatamsDic);
    NSDictionary *mappingAccess_token = [self configAccess_token];
    for (int i=0; i<totalPropCount; i++) {
        objc_property_t prop;
        const char *propName;
        if (i<propCount) {
            prop = properties[i];
            propName = property_getName(prop);
        }
        else {
            prop = superProperties[i-propCount];
            propName = property_getName(prop);
        }
        
        
        NSString *originalKey = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
        //忽略参数
        if (ignoreParams) {
            if ([ignoreParams containsObject:originalKey]) {
                continue;
            }
        }
        
        // 填充请求字典
        if(propName) {
            
            NSString *changeKey;
            
            if (i<propCount) {
                // 根据映射字典，修改请求参数名称
                if (mappingPatamsDic) {
                    PowerLog(originalKey);
                    PowerLog([mappingPatamsDic valueForKey:originalKey]);
                    changeKey = [mappingPatamsDic valueForKey:originalKey];
                    PowerLog(changeKey);
                }
                else {
                    changeKey = originalKey;
                }
            }
            else {
                if (mappingAccess_token) {
                    changeKey = [mappingAccess_token valueForKey:originalKey];
                }
                else {
                    changeKey = originalKey;
                }
            }
            
            
            id value = [self valueForKey:originalKey];
            PowerLog(value);
            if (value) {
                PowerLog(changeKey);
                if (changeKey) {
                    [params setObject:value forKey:changeKey];
                }
                else {
                    [params setObject:value forKey:originalKey];
                }
            }
            
        }
        
    }
    
    free(properties);
    free(superProperties);
    PowerLog(params);
    return params;
}

- (id)cacheArgument {
    unsigned int propCount;
    objc_property_t* properties = class_copyPropertyList([self class], &propCount);
    
    unsigned int superPropCount;
    objc_property_t* superProperties = class_copyPropertyList(NSClassFromString(@"BaseApi"), &superPropCount);
    
    unsigned int totalPropCount = propCount+superPropCount;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:totalPropCount];
    
    NSArray *onlyForSignParams = [self onlyForSignArgument];
    //    if ([self requestMethod] == YTKRequestMethodGet) {
    //        NSMutableArray *onlyForSignParamsM = [onlyForSignParams mutableCopy];
    //        [onlyForSignParamsM removeObjectAtIndex:0];
    //        [onlyForSignParamsM removeObjectAtIndex:1];
    //        onlyForSignParams = [onlyForSignParamsM copy];
    //    }
    
    NSArray *ignoreParams = [self ignoreArgument];
    
    //    id kindOfClass = [self componentUrlAppendArgument];
    //    NSArray *appendParams;
    //    if (kindOfClass) {
    //        if ([kindOfClass isKindOfClass:[NSArray class]]) {
    //            appendParams = kindOfClass;
    //        }
    //        else {
    //            appendParams = @[kindOfClass];
    //        }
    //    }
    
    if (ignoreParams) {
        ignoreParams = [ignoreParams arrayByAddingObjectsFromArray:onlyForSignParams];
    }
    else {
        ignoreParams = onlyForSignParams;
    }
    
    //    if (appendParams) {
    //        ignoreParams = [ignoreParams arrayByAddingObjectsFromArray:appendParams];
    //    }
    
    NSDictionary *mappingPatamsDic = [self configArgument];
    
    for (int i=0; i<totalPropCount; i++) {
        objc_property_t prop;
        const char *propName;
        if (i<propCount) {
            prop = properties[i];
            propName = property_getName(prop);
        }
        else {
            prop = superProperties[i-propCount];
            propName = property_getName(prop);
        }
        
        
        NSString *originalKey = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
        //忽略参数
        if (ignoreParams) {
            if ([ignoreParams containsObject:originalKey]) {
                continue;
            }
        }
        
        // 填充请求字典
        if(propName) {
            
            NSString *changeKey;
            
            // 根据映射字典，修改请求参数名称
            if (mappingPatamsDic) {
                
                changeKey = [mappingPatamsDic valueForKey:originalKey];
                
            }else{
                changeKey = originalKey;
            }
            
            id value = [self valueForKey:originalKey];
            
            if (value) {
                if (changeKey) {
                    [params setObject:value forKey:changeKey];
                }
                else {
                    [params setObject:value forKey:originalKey];
                }
            }
            
        }
        
    }
    
    free(properties);
    free(superProperties);
    return params;
}

- (NSString *)cacheKey {
    if (!_cacheKey) {
        NSDictionary *dic = [self cacheArgument];
        NSMutableString *cacheKey = [NSMutableString string];
        [cacheKey appendString:NSStringFromClass([self class])];
        [cacheKey appendString:@"?"];
        [dic enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
            [cacheKey appendFormat:@"%@=%@&", key, obj];
        }];
        [cacheKey deleteCharactersInRange:NSMakeRange(cacheKey.length-1, 1)];
        _cacheKey = [cacheKey copy];
    }
    return _cacheKey;
}

- (id)cacheFileNameFilterForRequestArgument:(id)argument {
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}

- (NSArray *)requestAuthorizationHeaderFieldArray {
    return nil;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return nil;
}

- (NSURLRequest *)buildCustomUrlRequest {
    return nil;
}

- (BOOL)useCDN {
    return NO;
}

- (id)jsonValidator {
    return nil;
}

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    if (statusCode >= 200 && statusCode <=299) {
        return YES;
    } else {
        return NO;
    }
}

- (AFConstructingBlock)constructingBodyBlock {
    return nil;
}

- (NSString *)resumableDownloadPath {
    return nil;
}

- (AFDownloadProgressBlock)resumableDownloadProgressBlock {
    return nil;
}

/// append self to request queue
- (void)start {
    [self toggleAccessoriesWillStartCallBack];
    [[YTKNetworkAgent sharedInstance] addRequest:self];
}

/// remove self from request queue
- (void)stop {
    [self toggleAccessoriesWillStopCallBack];
    self.delegate = nil;
    [[YTKNetworkAgent sharedInstance] cancelRequest:self];
    [self toggleAccessoriesDidStopCallBack];
}

- (BOOL)isExecuting {
    return self.requestOperation.isExecuting;
}

- (void)startWithCompletionBlockWithSuccess:(void (^)(YTKBaseRequest *request))success
                                    failure:(void (^)(YTKBaseRequest *request))failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(void (^)(YTKBaseRequest *request))success
                              failure:(void (^)(YTKBaseRequest *request))failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (id)responseJSONObject {
    return self.requestOperation.responseObject;
}

- (NSString *)responseString {
    return self.requestOperation.responseString;
}

- (NSInteger)responseStatusCode {
    return self.requestOperation.response.statusCode;
}

- (NSDictionary *)responseHeaders {
    return self.requestOperation.response.allHeaderFields;
}

#pragma mark - Request Accessoies

- (void)addAccessory:(id<YTKRequestAccessory>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}


//#pragma mark JSON To Model
//- (id)responseModel
//{
//    const char *requestClassName = class_getName([self class]);
//
//    NSString *responseModelName = [[NSString stringWithUTF8String:requestClassName] stringByReplacingOccurrencesOfString:@"Api" withString:@"Model"];
//
////    const char *responseModelNameChar = [responseModelName UTF8String];
//
//    id values = self.responseString;
////    id (*action)(id, SEL, id) = (id (*)(id, SEL, id)) objc_msgSend;
//
////    Class modelClass = object_getClass(NSClassFromString(responseModelName));
////    SEL sel = sel_registerName("mj_objectWithKeyValues:");
////    SEL sel = NSSelectorFromString(@"mj_objectWithKeyValues:");
////    id model = action(modelClass, sel, values);
////    if (!model) {
////        const char *responseModelNameChar = [[self responseModelName] UTF8String];
//    Class modelClass = NSClassFromString([self responseModelName]);
////        id model = action(modelClass, sel, values);
////    id model = objc_msgSend(modelClass, sel, values);
//    id model = [modelClass mj_objectWithKeyValues:values];
////    }
//    return model;
//}

#pragma mark JSON To Model
- (id)responseModel
{
    const char *requestClassName = class_getName([self class]);
    
    NSString *responseModelName = [[NSString stringWithUTF8String:requestClassName] stringByReplacingOccurrencesOfString:@"Api" withString:@"Model"];
    
    id values = self.requestOperation.responseString;
    PowerLog(self.requestOperation.responseString);
    Class modelClass = NSClassFromString(responseModelName);
    id model = [modelClass mj_objectWithKeyValues:values];
    if (!model) {
        Class modelClass = NSClassFromString([self responseModelName]);
        model = [modelClass mj_objectWithKeyValues:values];
    }
    return model;
}

- (id)cache
{
    return [[YYCache sharedCache] cacheForApi:self];
}

- (id)cacheModel
{
    const char *requestClassName = class_getName([self class]);
    
//    NSString *responseModelName = [[NSString stringWithUTF8String:requestClassName] stringByReplacingOccurrencesOfString:@"Api" withString:@"Model"];
    
    id values = [[YYCache sharedCache] cacheForApi:self];
    
//    Class modelClass = object_getClass(NSClassFromString(responseModelName));
//    id model = [modelClass mj_objectWithKeyValues:values];
    id model;
    if (!model) {
        Class modelClass = NSClassFromString([self responseModelName]);
        model = [modelClass mj_objectWithKeyValues:values];
    }
    return model;
}

- (NSArray *)ignoreArgument
{
    return nil;
}

- (NSDictionary *)configArgument
{
    return nil;
}

- (NSArray *)onlyForSignArgument
{
    return nil;
}

- (NSString *)responseModelName
{
    return nil;
}

- (id)componentUrlAppendArgument
{
    return nil;
}

- (NSDictionary *)componentUrlAppendArgumentToDictionary {
    NSMutableDictionary *appendParamDic = [NSMutableDictionary dictionary];
    id kindOfClass = [self componentUrlAppendArgument];
    if (kindOfClass) {
        NSArray *appendParams;
        if ([kindOfClass isKindOfClass:[NSArray class]]) {
            appendParams = kindOfClass;
        }
        else {
            appendParams = @[kindOfClass];
        }
        
        unsigned int propCount;
        objc_property_t* properties = class_copyPropertyList([self class], &propCount);
        
        for (int i=0; i<propCount; i++) {
            objc_property_t prop;
            const char *propName;
            prop = properties[i];
            propName = property_getName(prop);
            
            NSString *originalKey = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            
            if (appendParams) {
                [appendParams enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isEqualToString:originalKey]) {
                        [appendParamDic setObject:[self valueForKey:originalKey] forKey:obj];
                    }
                }];
            }
        }
    }
    return appendParamDic;
}

@end
