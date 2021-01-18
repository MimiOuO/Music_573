//
//  MioLrcView.h
//  573music
//
//  Created by Mimio on 2020/12/8.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicLyric.h"
NS_ASSUME_NONNULL_BEGIN

@class MioLrcView;

@protocol LyricViewDelegate <NSObject>

@optional

- (void)lyricView:(MioLrcView *)lyricView withProgress:(CGFloat)progress;

@end

@interface MioLrcView : UIView

@property (nonatomic, weak) id <LyricViewDelegate>delegate;
/// 歌词数组
@property (nonatomic, strong) NSArray<MusicLyric *> *lyrics;
/// 每行歌词的高度
@property (nonatomic, assign) NSInteger rowHeight;
/// 当前显示的歌词索引
@property (nonatomic, assign) NSInteger currentLyricIndex;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) NSInteger adjustLrcSec;

-(void)updateLrc;
@end

NS_ASSUME_NONNULL_END
