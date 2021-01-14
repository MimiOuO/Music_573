//
//  UICollectionView+FooterManager.h
//  573music
//
//  Created by Mimio on 2021/1/13.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (FooterManager)
/**是否开启<数据不满一页的话就自动隐藏下面的mj_footer>功能*/
@property(nonatomic, assign) BOOL autoHideMjFooter;
@end

NS_ASSUME_NONNULL_END
