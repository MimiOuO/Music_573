//
//  MioEmpty.h
//  orrilan
//
//  Created by Mimio on 2019/8/9.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "LYEmptyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MioEmpty : LYEmptyView

+ (instancetype)noDataEmpty;

+ (instancetype)noNetworkEmptyWithTarget:(id)target action:(SEL)action;

+ (instancetype)customEmptyViewWithTarget:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
