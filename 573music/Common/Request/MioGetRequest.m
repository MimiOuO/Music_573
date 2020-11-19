//
//  MioGetRequest.m
//  orrilan
//
//  Created by 吉格斯 on 2019/7/29.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioGetRequest.h"

@implementation MioGetRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}


- (id)initWithRequestUrl:(NSString *)url argument:(NSDictionary *)argument {
    
    self = [super init];
    if (self) {
        self.requestUrl = url;
        self.requestArgument = argument;
    }
    return self;
}


@end
