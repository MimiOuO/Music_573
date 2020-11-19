//
//  MioRequest.h
//  orrilan
//
//  Created by Duncan on 18/07/2019.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN
@class MioRequest;

typedef void(^MioRequestCompletionBlock)(NSDictionary *result);
typedef void(^MioRequestCompletionFailureBlock)(NSString *errorInfo);


@interface MioRequest : YTKRequest

/**
 请求URL地址
 */
@property(nonatomic, strong) NSString * requestUrl;

/**
 请求参数
 */
@property(nonatomic, strong) id requestArgument;

/**
 错误提示
 */
@property(nonatomic, strong) NSString * errorInfo;

/**
 请求类型
 */
@property(nonatomic, assign) YTKRequestSerializerType requestSerializerType;

/**
 是否校验json数据格式，默认yes
 */
@property(nonatomic, assign) BOOL verifyJSONFormat;

/**
 开始请求数据
 @param success 成功回调
 @param failure 失败回调，返回error信息
 */
- (void)success:(nullable MioRequestCompletionBlock)success
                                    failure:(nullable MioRequestCompletionFailureBlock)failure;
- (id)initWithRequestUrl:(NSString *)url argument:(NSDictionary *)argument;
@end

NS_ASSUME_NONNULL_END
