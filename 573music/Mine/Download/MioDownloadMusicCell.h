//
//  MioDownloadMusicCell.h
//  573music
//
//  Created by Mimio on 2021/2/8.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SJM3U8Download.h>
#import <SJM3U8DownloadListItem.h>
NS_ASSUME_NONNULL_BEGIN

@interface MioDownloadMusicCell : UITableViewCell
@property (nonatomic, strong) SJM3U8DownloadListItem *item;
@end

NS_ASSUME_NONNULL_END
