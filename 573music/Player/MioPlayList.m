//
//  MioPlayList.m
//  573music
//
//  Created by Mimio on 2020/11/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioPlayList.h"
@interface MioPlayList()
@property (nonatomic, strong) NSMutableArray *randomListArr;
@property (nonatomic, assign) NSInteger randomLocation;
@end

@implementation MioPlayList

+(MioPlayList *)shareInstance{
    static MioPlayList *playList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
          // 要使用self来调用
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
    }
    return self;
}

- (NSArray *)getCurrentPlayList{
    return _playListArr;
}

-(NSInteger)getPreIndex{
    if (!Equals(currentPlayOrder, MioPlayOrderRandom)) {//非随机
        if (mioPlayer.currentPlayIndex == 0) {
            return self.playListArr.count - 1;
        }else{
            return mioPlayer.currentPlayIndex - 1;
        }
    }else{//随机
        NSInteger index = random()%self.playListArr.count;
        return index;
    }
}

-(NSInteger)getNextIndex{
    if (!Equals(currentPlayOrder, MioPlayOrderRandom)) {//非随机
        if (mioPlayer.currentPlayIndex == self.playListArr.count - 1) {
            return 0;
        }else{
            return mioPlayer.currentPlayIndex + 1;
        }
    }else{//随机
        NSInteger index = random()%self.playListArr.count;
        return index;
    }
}

- (void)updatePlayList:(NSArray<MioMusicModel*> *)playListArr{
    _playListArr = [playListArr mutableCopy];
}

-(void)addLaterPlayList:(NSArray<MioMusicModel*> *)playListArr{
    
}

-(void)deletePlayListAtIndex:(NSInteger)index{
    
}

-(void)clearPlayList{
    
}

-(void)saveCurrentPlayList:(NSArray<MioMusicModel*> *)playListArr currentIndex:(NSInteger)index{
    
}

@end
