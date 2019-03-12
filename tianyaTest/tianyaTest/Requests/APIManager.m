//
//  APIManager.m
//  tianyaTest
//
//  Created by baiqiang on 2019/2/15.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "APIManager.h"

typedef NS_ENUM(NSUInteger, HostType) {
    HOST_DEBUG,
    HOST_RELEASE,
};

static HostType _type = HOST_DEBUG;

@implementation APIManager

+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask * , id ))success
                      failure:(void (^)(NSURLSessionDataTask * , NSError * ))failure {
    return [self GET:URLString parameters:parameters progress:nil success:success failure:failure];
}

+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                      success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                      failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    return [[self mananger] GET:[self setHostIpHeaderWithUrl:URLString] parameters:parameters progress:downloadProgress success:success failure:failure];;
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    return [self POST:URLString parameters:parameters progress:nil success:success failure:failure];
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    return [[self mananger] POST:[self setHostIpHeaderWithUrl:URLString] parameters:parameters progress:uploadProgress success:success failure:failure];
}


+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(nullable id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure {
     return [self POST:URLString parameters:parameters constructingBodyWithBlock:block progress:nil success:success failure:failure];
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(nullable id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nullable))uploadProgress
                       success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure {
     return [[self mananger] POST:[self setHostIpHeaderWithUrl:URLString] parameters:parameters constructingBodyWithBlock:block progress:nil success:success failure:failure];
}

+ (AFHTTPSessionManager *)mananger {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    return manager;
}

+ (NSString *)setHostIpHeaderWithUrl:(NSString *)urlString {
    if (![urlString hasPrefix:@"http"]) {
        NSArray * hostInfos = @[@"http://47.105.91.34:8080/",
                                @"http://47.105.91.34:8080/"];
        return [hostInfos[_type] stringByAppendingString:urlString];
    }
    return urlString;
}
@end
