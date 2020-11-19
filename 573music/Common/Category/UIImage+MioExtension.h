//
//  UIImage+MioExtension.h
//  jgsschool
//
//  Created by Mimio on 2020/9/16.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (MioExtension)
+(UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength;
@end

NS_ASSUME_NONNULL_END
