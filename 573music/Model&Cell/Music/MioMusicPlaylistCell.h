//
//  MioMusicPlaylistCell.h
//  573music
//
//  Created by Mimio on 2021/1/13.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MioMusicPlaylistCell : UITableViewCell
@property (nonatomic, strong) MioMusicModel *model;
@property (nonatomic, assign) BOOL isplaying;
@end

NS_ASSUME_NONNULL_END
