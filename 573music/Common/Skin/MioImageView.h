//
//  MioImageView.h
//  573music
//
//  Created by Mimio on 2020/11/23.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MioImageView : UIImageView
@property (nonatomic,copy) NSString * imageName;
@property (nonatomic,copy) NSString * colorName;
+(MioImageView *)creatImgView:(CGRect)frame inView:(UIView *)view skin:(NSString *)skin image:(NSString *)image radius:(CGFloat)radius;
+(MioImageView *)creatImgView:(CGRect)frame inView:(UIView *)view image:(NSString *)image bgTintColorName:(NSString *)colorName radius:(CGFloat)radius;
@end

NS_ASSUME_NONNULL_END
