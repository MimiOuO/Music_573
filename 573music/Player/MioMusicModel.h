//
//  MioMusicModel.h
//  573music
//
//  Created by Mimio on 2020/11/30.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAudioFile.h"
NS_ASSUME_NONNULL_BEGIN

@interface MioMusicModel : NSObject <DOUAudioFile,NSCopying>

@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * path;
@property (nonatomic,copy) NSString * audiourl;
@property (nonatomic,copy) NSString * noneurl;
@property (nonatomic,copy) NSString * lrc_url;



@property (nonatomic, strong) NSURL * audioFileURL;

@property (nonatomic,copy) NSString * savetype;

@end

NS_ASSUME_NONNULL_END