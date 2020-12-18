//
//  MioView.h
//  573music
//
//  Created by Mimio on 2020/11/23.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MioView : UIView
@property (nonatomic,copy) NSString * colorName;
+(MioView *)creatView:(CGRect)frame inView:(UIView *)view bgColorName:(NSString *)colorName radius:(CGFloat)radius;
@end

NS_ASSUME_NONNULL_END
