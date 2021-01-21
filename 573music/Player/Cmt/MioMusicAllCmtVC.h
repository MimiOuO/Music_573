//
//  MioMusicAllCmtVC.h
//  573music
//
//  Created by Mimio on 2021/1/4.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioViewController.h"
#import "MioCmtModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol MioRefreshMusicCmtDelegate <NSObject>
@optional

- (void)refreshCmt;
- (void)likeCmt:(MioCmtModel *)cmtModel;
@end
@interface MioMusicAllCmtVC : MioViewController
//@property (nonatomic,strong)MusicInfo *musicInfo;
@property (nonatomic, strong) MioCmtModel *cmtModel;
@property (nonatomic , weak) id <MioRefreshMusicCmtDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
