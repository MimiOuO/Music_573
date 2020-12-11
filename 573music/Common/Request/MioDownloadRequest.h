//
//  MioDownloadRequest.h
//  573music
//
//  Created by Mimio on 2020/12/8.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MioDownloadRequest : YTKRequest

@property (nonatomic,copy) NSString * url;
@property (nonatomic,copy) NSString * cachePath;
@property (nonatomic,copy) NSString * lrcName;

- (instancetype)initWinthUrl:(NSString *)url fileName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
