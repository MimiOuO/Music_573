//
//  UILabel+MioExtension.m
//  longtengyuan
//
//  Created by Mimio on 2019/6/2.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "UILabel+MioExtension.h"

@implementation UILabel (MioExtension)

+(UILabel *)creatLabelinView:(UIView *)view text:(NSString *)text color:(UIColor *)color size:(CGFloat)fontSize{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:fontSize];
    [view addSubview:label];
    return label;
}

+(UILabel *)creatLabel:(CGRect)frame inView:(UIView *)view text:(NSString *)text color:(UIColor *)color size:(CGFloat)fontSize{
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.text = text;
	label.textColor = color;
	label.font = [UIFont systemFontOfSize:fontSize];
	[view addSubview:label];
	return label;
}

+(UILabel *)creatLabel:(CGRect)frame inView:(UIView *)view text:(NSString *)text color:(UIColor *)color size:(CGFloat)fontSize alignment:(NSTextAlignment)alignment{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = alignment;
    [view addSubview:label];
    return label;
}

+(UILabel *)creatLabel:(CGRect)frame inView:(UIView *)view text:(NSString *)text color:(UIColor *)color boldSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.font = [UIFont boldSystemFontOfSize:fontSize];
    label.textAlignment = alignment;
    [view addSubview:label];
    return label;
}
@end
