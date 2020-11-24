//
//  MioGetCacheRequest.h
//  573music
//
//  Created by Mimio on 2020/11/24.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioGetRequest.h"
#import "MioRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MioGetCacheRequest : MioRequest

- (id)initWithRequestUrl:(NSString *)url argument:(NSDictionary *)argument;

@end

NS_ASSUME_NONNULL_END
