//
//  MioMusicPlaylistCell.h
//  573music
//
//  Created by Mimio on 2021/1/13.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MioMusicPlaylistCell;
typedef void (^deleteBlock) (MioMusicPlaylistCell *);
typedef void (^fromClickBlock) (MioMusicPlaylistCell *);

@interface MioMusicPlaylistCell : UITableViewCell
@property (nonatomic, strong) MioMusicModel *model;
@property (nonatomic, assign) BOOL isplaying;
@property(nonatomic, copy) deleteBlock deleteBlock;
@property(nonatomic, copy) fromClickBlock fromClickBlock;
@end

NS_ASSUME_NONNULL_END
