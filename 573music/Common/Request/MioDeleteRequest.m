//
//  MioDeleteRequest.m
//  orrilan
//
//  Created by 吉格斯 on 2019/7/29.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioDeleteRequest.h"

@implementation MioDeleteRequest
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodDELETE;
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
