//
//  UITableView+MioExtension.h
//  jgsschool
//
//  Created by Mimio on 2020/10/27.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (MioExtension)
+(UITableView *)creatTable:(CGRect)frame inView:(UIView *)view vc:(UIViewController *)vc;
@end

NS_ASSUME_NONNULL_END
