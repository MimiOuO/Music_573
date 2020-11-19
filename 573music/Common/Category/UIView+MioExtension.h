//
//  UIView+MioExtension.h
//  longtengyuan
//
//  Created by Mimio on 2019/6/2.
//  Copyright © 2019 Brance. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIView (MioExtension)
@property (nullable, nonatomic, readonly) UIViewController *viewController;
@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  size;        ///< Shortcut for frame.size.
+(UIView *)creatViewWinView:(UIView *)view bgColor:(UIColor *)bgColor;
+(UIView *)creatView:(CGRect)frame inView:(UIView *)view bgColor:(UIColor *)bgColor radius:(CGFloat)radius;
+(UIView *)creatView:(CGRect)frame inView:(UIView *)view bgColor:(UIColor *)bgColor;
- (void)removeAllSubviews;

/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
- (void)whenTapped:(void (^)())block;
@end
NS_ASSUME_NONNULL_END
