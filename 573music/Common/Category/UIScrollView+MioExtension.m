//
//  UIScrollView+MioExtension.m
//  jgsschool
//
//  Created by Mimio on 2020/9/8.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "UIScrollView+MioExtension.h"

@implementation UIScrollView (MioExtension)
+(UIScrollView *)creatScroll:(CGRect)frame inView:(UIView *)view contentSize:(CGSize)contentSize{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:frame];
    scroll.contentSize = contentSize;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    [view addSubview:scroll];
    return scroll;
}
@end
