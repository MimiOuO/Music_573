//
//  MioPlayList.m
//  573music
//
//  Created by Mimio on 2020/11/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioPlayList.h"
#import <WHC_ModelSqlite.h>

@interface MioPlayList()
@property (nonatomic, strong) NSMutableArray *randomListArr;
@property (nonatomic, assign) NSInteger randomLocation;
@end

@implementation MioPlayList

+(MioPlayList *)shareInstance{
    static MioPlayList *playList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playList = [[MioPlayList alloc]init];
    });
    return playList;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _playListArr = [[NSMutableArray alloc] init];
        _randomListArr = [[NSMutableArray alloc] init];
        _randomLocation = 0;
        _currentPlayIndex = -1;
        
        _playListArr = [[WHCSqlite query:[MioMusicModel class]  where:@"savetype = 'playList'"] mutableCopy];
        _currentPlayIndex = getPlayIndex;
        WEAKSELF;
        [self xw_addObserverBlockForKeyPath:@"playListArr" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            NSLog(@"播放列表变化");
            [weakSelf saveCurrentPlayList];
        }];

         [self xw_addObserverBlockForKeyPath:@"currentPlayIndex" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
             NSLog(@"index变化");
             [weakSelf saveCurrentIndex];
         }];
    }
    return self;
}

//- (NSInteger)currentPlayIndex{
//    _currentPlayIndex = [mioPlayList.playListArr indexOfObject:self.currentMusic];
//    return _currentPlayIndex;
//}





#pragma mark - 更新Index
-(void)updateCurrentIndex:(MioMusicModel *)music{
    if (self.playListArr.count == 0) {
        self.currentPlayIndex = -1;
    }else{
        self.currentPlayIndex = [self.playListArr indexOfObject:music];
    }
}
#pragma mark - 更新列表操作
- (void)updatePlayList:(NSArray<MioMusicModel*> *)playListArr{
    self.playListArr = [playListArr mutableCopy];
}

-(void)addLaterPlayList:(NSArray<MioMusicModel*> *)playListArr{
    
}

-(void)deletePlayListAtIndex:(NSInteger)index{
    
}

-(void)clearPlayList{
//    NSArray *a = [WHCSqlite query:[MioMusicModel class]  where:@"savetype = 'playList'"];
//    NSInteger b = getPlayIndex;
//    NSLog(@"%@",a);
}

-(void)saveCurrentIndex{
    NSLog(@"%ld",(long)self.currentPlayIndex);
    setPlayIndex(self.currentPlayIndex);
}

-(void)saveCurrentPlayList{
    [WHCSqlite delete:[MioMusicModel class] where:@"savetype = 'playList'"];
    
    for (MioMusicModel *music in self.playListArr) {
        music.savetype = @"playList";
    }
    
    [WHCSqlite inserts:mioPlayList.playListArr];
    
}

#pragma mark - KVO


#pragma mark - 获取上一曲 下一曲
-(NSInteger)getPreIndex{
    if (!Equals(currentPlayOrder, MioPlayOrderRandom)) {//非随机
        if (mioPlayList.currentPlayIndex == 0) {
            return self.playListArr.count - 1;
        }else{
            return mioPlayList.currentPlayIndex - 1;
        }
    }else{//随机
        NSInteger index = random()%self.playListArr.count;
        return index;
    }
}

-(NSInteger)getNextIndex{
    if (!Equals(currentPlayOrder, MioPlayOrderRandom)) {//非随机
        if (mioPlayList.currentPlayIndex == self.playListArr.count - 1) {
            return 0;
        }else{
            return mioPlayList.currentPlayIndex + 1;
        }
    }else{//随机
        NSInteger index = random()%self.playListArr.count;
        return index;
    }
}

-(NSInteger)getAutoPlayIndex{
    if (!Equals(currentPlayOrder, MioPlayOrderRandom)) {//非随机
        if (Equals(currentPlayOrder, MioPlayOrderCycle)) {//循环
            if (mioPlayList.currentPlayIndex == self.playListArr.count - 1) {
                return 0;
            }else{
                return mioPlayList.currentPlayIndex + 1;
            }
        }else{//单曲
            return mioPlayList.currentPlayIndex;
        }

    }else{//随机
        NSInteger index = random()%self.playListArr.count;
        return index;
    }
}


@end
