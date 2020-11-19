//
//  MioAddRequest.h
//  orrilan
//
//  Created by 吉格斯 on 2019/7/29.
//  Copyright © 2019 Brance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MioRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MioPostRequest : MioRequest
/**
 GET 请求
 
 @param url 网址
 @param argument 参数
 @return HXRequest
 */
- (id)initWithRequestUrl:(NSString *)url argument:(NSDictionary *)argument;

@end

NS_ASSUME_NONNULL_END
