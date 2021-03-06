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


@protocol MutipleDeleteDelegate <NSObject>
@optional
- (void)mutipleDelete:(NSArray<MioMusicModel *> *)selectArr;
@end

@interface MioMutipleVC : MioViewController
@property (nonatomic, weak) id<MutipleDeleteDelegate> delegate;
@property (nonatomic, strong) NSArray<MioMusicModel *> *musicArr;
@property (nonatomic, assign) MioMutipleType type;
@property (nonatomic, copy) NSString * songlistId;
@property (nonatomic, assign) MioFromType fromModel;
@property (nonatomic,copy) NSString * fromId;
@end

NS_ASSUME_NONNULL_END
