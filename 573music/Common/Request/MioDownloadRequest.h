//
//  MioDownloadRequest.h
//  573music
//
//  Created by Mimio on 2020/12/8.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN
@class MioDownloadRequest;

typedef void(^MioRequestCompletionBlock)(NSDictionary *result);
typedef void(^MioRequestCompletionFailureBlock)(NSString *errorInfo);

@interface MioDownloadRequest : YTKRequest

@property (nonatomic,copy) NSString * url;
@property (nonatomic,copy) NSString * cachePath;
@property (nonatomic,copy) NSString * lrcName;
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

- (instancetype)initWinthUrl:(NSString *)url fileName:(NSString *)name;

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
