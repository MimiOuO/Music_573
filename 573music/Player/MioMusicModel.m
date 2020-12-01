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
    return [_audiourl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


@end
