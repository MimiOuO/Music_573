//
//  UILabel+MioExtension.h
//  longtengyuan
//
//  Created by Mimio on 2019/6/2.
//  Copyright © 2019 Brance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UILabel (MioExtension)
+(UILabel *)creatLabelinView:(UIView *)view text:(NSString *)text color:(UIColor *)color size:(CGFloat)fontSize;
+(UILabel *)creatLabel:(CGRect)frame inView:(UIView *)view text:(NSString *)text color:(UIColor *)color size:(CGFloat)fontSize;
+(UILabel *)creatLabel:(CGRect)frame inView:(UIView *)view text:(NSString *)text color:(UIColor *)color size:(CGFloat)fontSize alignment:(NSTextAlignment)alignment;
+(UILabel *)creatLabel:(CGRect)frame inView:(UIView *)view text:(NSString *)text color:(UIColor *)color boldSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment;

@end
NS_ASSUME_NONNULL_END
