//
//  MioAFPutRequest.h
//  DuoDuoPeiwan
//
//  Created by Mimio on 2019/9/20.
//  Copyright © 2019 Brance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**定义请求成功的block*/
typedef void(^requestSuccess)( NSDictionary * object);

/**定义请求失败的block*/
typedef void(^requestFailure)( NSError *error);

@interface MioAFPutRequest : NSObject

+(instancetype)shareManager;

+(void)requestWithUrl:(NSString *)urlString params:(id)paraments successBlock:(requestSuccess)successBlock failureBlock:(requestFailure)failureBlock;

@end

NS_ASSUME_NONNULL_END
