//
//  MioSingerModel.h
//  573music
//
//  Created by Mimio on 2020/12/17.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MioSingerModel : NSObject
@property (nonatomic,copy) NSString * singer_id;
@property (nonatomic,copy) NSString * singer_name;
@property (nonatomic,copy) NSString * singer_intro;
@property (nonatomic,copy) NSString * cover_image_path;
@property (nonatomic,copy) NSString * like_num;
@property (nonatomic,copy) NSString * songs_num;
@property (nonatomic,copy) NSString * albums_num;
@property (nonatomic,copy) NSString * mvs_num;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, assign) BOOL is_like;
@end

NS_ASSUME_NONNULL_END
