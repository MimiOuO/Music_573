//
//  UIImageView+MioExtension.h
//  longtengyuan
//
//  Created by Mimio on 2019/6/2.
//  Copyright © 2019 Brance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIImageView (MioExtension)
+(UIImageView *)creatImginView:(UIView *)view image:(NSString *)image radius:(CGFloat)radius;
+(UIImageView *)creatImgView:(CGRect)frame inView:(UIView *)view image:(NSString *)image radius:(CGFloat)radius;
+(UIImageView *)creatImgView:(CGRect)frame inView:(UIView *)view image:(NSString *)image bgTintColor:(UIColor *)color radius:(CGFloat)radius;
@end
NS_ASSUME_NONNULL_END
