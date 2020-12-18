//
//  MioMusicTableCell.h
//  573music
//
//  Created by Mimio on 2020/12/17.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MioMusicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MioMusicTableCell : UITableViewCell
@property (nonatomic, strong) MioMusicModel *model;
@end

NS_ASSUME_NONNULL_END
