//
//  MioMVAllCmtVC.h
//  573music
//
//  Created by Mimio on 2021/1/5.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioViewController.h"
#import "MioCmtModel.h"
@protocol MioRefreshMusicCmtDelegate <NSObject>
@optional

- (void)refreshCmt;

@end
@interface MioMVAllCmtVC : MioViewController
//@property (nonatomic,strong)MusicInfo *musicInfo;
@property (nonatomic, strong) MioCmtModel *cmtModel;
@property (nonatomic , weak) id <MioRefreshMusicCmtDelegate> delegate;
@end
