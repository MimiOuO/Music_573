//
//  MioPlayList.m
//  573music
//
//  Created by Mimio on 2020/11/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioPlayList.h"
@interface MioPlayList()

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
    }
    return self;
}

- (NSArray *)getCurrentPlayList{
    return _playListArr;
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



@end
