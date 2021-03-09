//
//  MioPlayList.h
//  573music
//
//  Created by Mimio on 2020/11/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol MioPlayListDelegate <NSObject>
@optional

@end


@interface MioPlayList : NSObject
@property (nonatomic, weak) id <MioPlayListDelegate> delegate;

//以下两个属性应该为readonly 但是为了出发KVO就没写，请不要直接操作这两个属性
@property (nonatomic, assign) NSInteger currentPlayIndex;
@property (nonatomic, strong) NSMutableArray<MioMusicModel*> *playListArr;


+(MioPlayList *)shareInstance;

-(void)updateCurrentIndex:(MioMusicModel *)music;

-(void)updatePlayList:(NSArray<MioMusicModel*> *)playListArr;
-(void)addLaterPlayList:(NSArray<MioMusicModel*> *)playListArr fromModel:(MioFromType)from andId:(NSString *)fromId;
-(void)deletePlayListAtIndex:(NSInteger)index;
-(void)deletePlayListById:(NSString *)song_id;
-(void)clearPlayList;


-(NSInteger)getPreIndex;
-(NSInteger)getNextIndex;
-(NSInteger)getAutoPlayIndex;
@end

NS_ASSUME_NONNULL_END
