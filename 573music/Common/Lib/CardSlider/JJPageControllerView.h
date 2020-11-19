//
//  JJPageControllerView.h
//  CardSliderDome
//
//  Created by  张礼栋 on 2019/12/10.
//  Copyright © 2019 mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJPageControllerView : UIView
@property(nonatomic, strong)NSMutableArray *pageControlArray;
- (void)setAllCount:(NSInteger)count;
- (void)setIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
