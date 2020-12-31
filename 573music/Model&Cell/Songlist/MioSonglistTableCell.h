//
//  MioSonglistTableCell.h
//  573music
//
//  Created by Mimio on 2020/12/31.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MioSongListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MioSonglistTableCell : UITableViewCell
@property (nonatomic, strong) MioSongListModel *model;
@end

NS_ASSUME_NONNULL_END
