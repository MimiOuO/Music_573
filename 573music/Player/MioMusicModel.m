//
//  MioMusicModel.m
//  573music
//
//  Created by Mimio on 2020/11/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMusicModel.h"

@implementation MioMusicModel

- (NSString *)audiourl{
    if (_audiourl.length > 0) {
        return [_audiourl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else{
        return [_noneurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
}

- (NSURL *)audioFileURL{
    return [NSURL URLWithString:self.audiourl];
}

@end
