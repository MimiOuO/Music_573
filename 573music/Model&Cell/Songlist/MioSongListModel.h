//
//  MioSongListModel.h
//  573music
//
//  Created by Mimio on 2020/12/17.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MioSongListModel : NSObject
@property (nonatomic,copy) NSString * song_list_id;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * song_list_description;
@property (nonatomic,copy) NSString * cover_image_path;
@property (nonatomic,copy) NSString * user_id;
@property (nonatomic,copy) NSString * username;
@property (nonatomic,copy) NSString * song_num;
@property (nonatomic,copy) NSString * hits_all;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSArray *song_ids;
@property (nonatomic, strong) NSArray *songs;
@property (nonatomic, assign) BOOL is_like;
@property (nonatomic,copy) NSString * like_num;
@property (nonatomic, strong) NSDictionary *songs_paginate;
@end

NS_ASSUME_NONNULL_END
