//
//  MioRadioView.h
//  573music
//
//  Created by Mimio on 2021/1/5.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MioSongListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MioRadioView : UIView
@property (nonatomic, strong) MioSongListModel *model;
@end

NS_ASSUME_NONNULL_END
