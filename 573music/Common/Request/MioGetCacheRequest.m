//
//  MioGetCacheRequest.m
//  573music
//
//  Created by Mimio on 2020/11/24.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioGetCacheRequest.h"

@implementation MioGetCacheRequest

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



- (NSInteger)cacheTimeInSeconds{
    return 60*60*24*365;
}

@end



