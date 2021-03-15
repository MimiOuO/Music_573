//
//  MioRankMusicTableCell.h
//  573music
//
//  Created by Mimio on 2021/3/15.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MioRankMusicTableCell : UITableViewCell
@property (nonatomic, strong) MioMusicModel *model;
@property (nonatomic, strong) UILabel *rankLab;
@end

NS_ASSUME_NONNULL_END
