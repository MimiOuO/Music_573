//
//  UIButton+MioExtension.h
//  longtengyuan
//
//  Created by Mimio on 2019/6/1.
//  Copyright © 2019 Brance. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^ButtonSenderBlock) (UIButton* sender);
@interface UIButton (MioExtension)
@property (nonatomic, strong) NSString *extra;
@property(nonatomic,copy)ButtonSenderBlock block;
+(UIButton *)creatBtninView:(UIView *)view bgImage:(NSString *)image WithTag:(NSInteger)tag target:(id)vc action:(SEL)action;
+(UIButton *)creatBtninView:(UIView *)view bgColor:(UIColor *)color title:(NSString *)title WithTag:(NSInteger)tag target:(id)vc action:(SEL)action;

+(UIButton *)creatBtn:(CGRect)frame inView:(UIView *)view bgImage:(NSString *)image WithTag:(NSInteger)tag target:(id)vc action:(SEL)action;
+(UIButton *)creatBtn:(CGRect)frame inView:(UIView *)view bgColor:(UIColor *)color title:(NSString *)title WithTag:(NSInteger)tag target:(id)vc action:(SEL)action;


+(UIButton *)creatBtn:(CGRect)frame inView:(UIView *)view bgImage:(NSString *)image action:(void (^)())block;

+(UIButton *)creatBtn:(CGRect)frame inView:(UIView *)view bgImage:(NSString *)image bgTintColor:(UIColor *)color action:(void (^)())block;
+(UIButton *)creatBtn:(CGRect)frame inView:(UIView *)view bgColor:(UIColor *)color title:(NSString *)title titleColor:(UIColor *)titleColor font:(CGFloat)fontSize radius:(CGFloat)radius action:(void (^)())block;

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end
NS_ASSUME_NONNULL_END
