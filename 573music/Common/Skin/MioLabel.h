//
//  MioLabel.h
//  573music
//
//  Created by Mimio on 2020/11/23.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MioLabel : UILabel
@property (nonatomic,copy) NSString * colorName;
+(MioLabel *)creatLabel:(CGRect)frame inView:(UIView *)view text:(NSString *)text colorName:(NSString *)colorName size:(CGFloat)fontSize alignment:(NSTextAlignment)alignment;
+(MioLabel *)creatLabel:(CGRect)frame inView:(UIView *)view text:(NSString *)text colorName:(NSString *)colorName boldSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment;
@end

NS_ASSUME_NONNULL_END
