//
//  MioUploadRequest.m
//  573music
//
//  Created by Mimio on 2020/12/17.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioUploadRequest.h"

@implementation MioUploadRequest{
    UIImage *_image;
}

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)initWithRequestUrl:(NSString *)url argument:(id)argument constructingBodyBlock:(nullable AFConstructingBlock)block{
    
    self = [super init];
    if (self) {
        self.requestUrl = url;
        self.requestArgument = argument;
        self.constructingBodyBlock = block;//直接赋值过去即可
    }
    return self;
}

- (id)jsonValidator {
    return @{ @"file": [NSString class] };
}

- (NSString *)responseImageId {
    NSDictionary *dict = self.responseJSONObject;
    return dict[@"file"];
}


@end
