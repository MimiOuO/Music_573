//
//  UIWindow+MioExtension.h
//  jgsschool
//
//  Created by Mimio on 2020/9/3.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (MioExtension)
+(void)showInfo:(NSString *)text;
+(void)showSuccess:(NSString *)text;
+(void)showLoading:(NSString *)text;
+(void)showMaskLoading:(NSString *)text;
+(void)hiddenLoading;

+(void)showMessage:(NSString *)message withTitle:(NSString *)title;
@end

@interface MioHUD : UIView
@property (assign, nonatomic) BOOL isImage;
@property (copy, nonatomic) NSString *text;
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text;
- (void)showloading;
@end

@interface MioBgView : UIView

@end

NS_ASSUME_NONNULL_END
