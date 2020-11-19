//
//  MioLargeButton.h
//  DuoDuoPeiwan
//
//  Created by Mimio on 2019/10/29.
//  Copyright © 2019 Brance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MioLargeButton : UIButton
/**
 *  对button的上、左、下、右点击区域进行扩大，正数表示缩小点击区域
 *  button.clickEdgeInsets = UIEdgeInsetsMake(-1, -2, -3, -4);
 */
@property (nonatomic, assign) UIEdgeInsets clickEdgeInsets;

///成倍扩大点击区域，传值<=1点击区域不变
@property (nonatomic, assign) CGFloat clickScale;

///成倍扩大横向点击区域，传值<=1点击区域不变
@property (nonatomic, assign) CGFloat clickWidthScale;

///成倍扩大纵向点击区域，传值<=1点击区域不变
@property (nonatomic, assign) CGFloat clickHeightScale;

///是否显示点击区域，供调试使用，默认为NO，半透明的红色区域就是点击区域
@property (nonatomic, assign) BOOL showClickArea;

@end

NS_ASSUME_NONNULL_END
