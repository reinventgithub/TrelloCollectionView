//
//  BaseApi.m
//
//
//  Created by wxl on 16/2/25.
//  Copyright © 2015年 Aim. All rights reserved.
//

#import "BaseApi.h"
#import <objc/runtime.h>

@implementation BaseApi

//- (YTKRequestSerializerType)requestSerializerType
//{
//    return YTKRequestSerializerTypeJSON;
//}
//
//- (NSDictionary *)requestHeaderFieldValueDictionary
//{
//    return @{@"apikey": @"61979cba44a3b9abb16c5127574dd2e5"};
//}

- (NSString *)access_token {
    if (!_access_token) {
//        _access_token = [LLBSingleton sharedSingleton].loginUser.accessToken;
    }
    return _access_token;
}

- (NSString *)appsercert {
    if (!_appsercert) {
//        _appsercert = [LLBSingleton sharedSingleton].loginUser.appsercert;
    }
    return _appsercert;
}

- (NSString *)sign {
    if (!_sign) {
        unsigned int propCount;
        objc_property_t* properties = class_copyPropertyList([self class], &propCount);
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:propCount];
        
        NSArray *ignoreParams = [self ignoreArgument];
        NSDictionary *mappingPatamsDic = [self configArgument];
        
        for (int i=0; i<propCount; i++) {
            objc_property_t prop = properties[i];
            const char *propName = property_getName(prop);
            
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
                }
                else {
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
        [params setObject:self.access_token forKey:@"access-token"];
        [params setObject:self.appsercert forKey:@"appsercert"];
        [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [params removeObjectForKey:key];
            [params setObject:obj forKey:[key lowercaseString]];
        }];
//        _sign = [APPUtil createSign:params];
    }
    
    return _sign;
}

- (NSArray *)onlyForSignArgument {
    return @[@"access_token", @"appsercert", @"sign"];
}

- (NSArray *)onlyForSignArgumentForGet {
    return @[@"appsercert"];
}

- (NSDictionary *)configAccess_token {
    return @{@"access_token" : @"access-token"};
}

- (NSString *)requestUrl {
    NSString *requestUrl = [self componentUrl];
    
    NSDictionary *appendParamDic = [self componentUrlAppendArgumentToDictionary];
    if (appendParamDic.count) {
        NSMutableString *appendParamsString = [NSMutableString string];
        [appendParamDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [appendParamsString appendString:@"/"];
            [appendParamsString appendString:[NSString stringWithFormat:@"%@", obj]];
        }];
        if (self.requestMethod == YTKRequestMethodGet) {
            return [NSString stringWithFormat:@"%@%@", requestUrl, appendParamsString];
        }
        else {
            return [NSString stringWithFormat:@"%@%@?access-token=%@&sign=%@", requestUrl, appendParamsString, self.access_token, self.sign];
        }
    }
    else {
        if (self.requestMethod == YTKRequestMethodGet) {
            return requestUrl;
        }
        else {
            return [NSString stringWithFormat:@"%@?access-token=%@&sign=%@", requestUrl, self.access_token, self.sign];
        }
    }
}

@end
