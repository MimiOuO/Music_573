//
//  MioAFPutRequest.m
//  DuoDuoPeiwan
//
//  Created by Mimio on 2019/9/20.
//  Copyright © 2019 Brance. All rights reserved.
//
#import <AFNetworking.h>
#import "MioAFPutRequest.h"

@implementation MioAFPutRequest

//+(instancetype)shareManager{
//
//}

+(void)requestWithUrl:(NSString *)urlString params:(id)params successBlock:(requestSuccess)successBlock failureBlock:(requestFailure)failureBlock{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    //调出请求头
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //将token封装入请求头
    
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[userdefault objectForKey:@"token"]] forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    
    AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
    [mgr.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil]];
    
    [mgr PUT:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureBlock(error);
    }];
}

@end
