//
//  MioSongListModel.m
//  573music
//
//  Created by Mimio on 2020/12/17.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioSongListModel.h"

@implementation MioSongListModel

- (NSArray *)songs{
    if (self.songs_paginate) {
        return self.songs_paginate[@"data"];
    }else{
        return _songs;
    }
    
}

@end
