//
//  MioMutipleVC.h
//  573music
//
//  Created by Mimio on 2020/12/9.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioViewController.h"

typedef NS_ENUM(NSUInteger, MioMutipleType) {
    MioMutipleTypePlayList ,
    MioMutipleTypeSongList,
    MioMutipleTypeDownloadList,
    MioMutipleTypeOwnSongList,
    MioMutipleTypeLocalList
};


NS_ASSUME_NONNULL_BEGIN

@interface MioMutipleVC : MioViewController
@property (nonatomic, strong) NSArray<MioMusicModel *> *musicArr;
@property (nonatomic, assign) MioMutipleType type;
@property (nonatomic,copy) NSString * songlistId;
@end

NS_ASSUME_NONNULL_END
