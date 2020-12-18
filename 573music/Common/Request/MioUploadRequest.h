//
//  MioUploadRequest.h
//  573music
//
//  Created by Mimio on 2020/12/17.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MioUploadRequest : MioRequest
- (id)initWithRequestUrl:(NSString *)url argument:(id)argument constructingBodyBlock:(nullable AFConstructingBlock)block;

- (id)initWithImage:(UIImage *)image;
- (NSString *)responseImageId;
@end

NS_ASSUME_NONNULL_END
