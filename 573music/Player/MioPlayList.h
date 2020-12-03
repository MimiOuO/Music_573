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
@property (nonatomic, strong, readonly) NSMutableArray<MioMusicModel*> *playListArr;//不能直接操作，通过方法去改变列表


+(MioPlayList *)shareInstance;

-(void)updatePlayList:(NSArray<MioMusicModel*> *)playListArr;
-(void)addLaterPlayList:(NSArray<MioMusicModel*> *)playListArr;
-(void)deletePlayListAtIndex:(NSInteger)index;
-(void)clearPlayList;

-(void)saveCurrentPlayList:(NSArray<MioMusicModel*> *)playListArr currentIndex:(NSInteger)index;

-(NSInteger)getPreIndex;
-(NSInteger)getNextIndex;
@end

NS_ASSUME_NONNULL_END
