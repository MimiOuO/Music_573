//
//  MioButton.h
//  573music
//
//  Created by Mimio on 2020/12/11.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MioButton : UIButton
@property (nonatomic,copy) NSString * colorName;
+(MioButton *)creatBtn:(CGRect)frame inView:(UIView *)view bgImage:(NSString *)image bgTintColorName:(NSString *)colorName action:(void (^)())block;
@end

NS_ASSUME_NONNULL_END
