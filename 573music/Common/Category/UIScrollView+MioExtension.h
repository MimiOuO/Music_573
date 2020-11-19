//
//  UIScrollView+MioExtension.h
//  jgsschool
//
//  Created by Mimio on 2020/9/8.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (MioExtension)
+(UIScrollView *)creatScroll:(CGRect)frame inView:(UIView *)view contentSize:(CGSize)contentSize;
@end

NS_ASSUME_NONNULL_END
