//
//  MioRequest.m
//  orrilan
//
//  Created by Duncan on 18/07/2019.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioRequest.h"
#import "YTKNetworkConfig.h"


@implementation MioRequest


- (id)initWithRequestUrl:(NSString *)url argument:(NSDictionary *)argument {
    
    self = [super init];
    if (self) {
        //        [YTKNetworkConfig sharedConfig].debugLogEnabled = YES;  //开启Debug模式
        //        self.verifyJSONFormat = YES;
        self.requestUrl = url;
        self.requestArgument = argument;
    }
    return self;
}


- (NSTimeInterval)requestTimeoutInterval {
    return 10;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    
    return @{
             @"Authorization":[NSString stringWithFormat:@"Bearer %@",[userdefault objectForKey:@"token"]],
             @"Accept":@"application/json"
             };
}


//- (id)jsonValidator {
//    if (self.verifyJSONFormat) {
//        return @{
//                 @"data": [NSObject class],
//                 @"success": [NSNumber class],
//                 @"message": [NSString class]
//                 };
//    }else
//    {
//        return nil;
//    }
//}




- (void)success:(nullable MioRequestCompletionBlock)success
                                    failure:(nullable MioRequestCompletionFailureBlock)failure
{
    
    
    [super startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSDictionary *result = [request responseJSONObject];
        
        BOOL isSuccess = YES;
        
        //校验格式
        if (self.verifyJSONFormat) {
            isSuccess = [[result objectForKey:@"success"] boolValue];
        }
        
        success(result);
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        failure(self.errorInfo);
    }];
}



- (NSString *)description {

    //打印自己认为重要的信息
    return [NSString stringWithFormat:@"%@ \nstatusCode:%ld\nresponseJSONObject:\n%@",super.description,self.responseStatusCode,self.responseJSONObject];
}

- (NSString *)errorInfo {
    NSString * info = @"";
    if (self.responseStatusCode) {
//        if (request.error.code==NSURLErrorNotConnectedToInternet) {
//            info = @"请检查网络!";
//        }else if (request.error.code==NSURLErrorTimedOut) {
//            info = @"请求超时,请重试!";
//        }else
        if (self.responseStatusCode == 401) {
            info = @"授权失败";
            //[svprogressHUD showErrorWithStatus:@"登录已过期，请重新登录"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];

            
        }else if (self.responseStatusCode== 500) {
            info = @"服务器报错,请稍后再试!";
        }else
        {
            info = [self.responseObject objectForKey:@"message"];
        }
    }
    
    return info;
}



@end
