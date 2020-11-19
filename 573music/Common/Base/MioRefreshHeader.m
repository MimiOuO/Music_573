//
//  MioRefreshHeader.m
//  DuoDuoPeiwan
//
//  Created by Mimio on 2019/10/22.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioRefreshHeader.h"

@implementation MioRefreshHeader

- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<35; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"合成 %zd", i + 99]];
        [idleImages addObject:image];
    }
     [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<35; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"合成 %zd",  i + 100]];
        [refreshingImages addObject:image];
    }
    
    [self setImages:idleImages duration:1.0 forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages duration:0.8 forState:MJRefreshStateRefreshing];
    
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;

    // 隐藏状态
    self.stateLabel.hidden = YES;
    
}

@end
