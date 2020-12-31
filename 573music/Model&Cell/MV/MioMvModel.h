//
//  MioMVModel.h
//  573music
//
//  Created by Mimio on 2020/12/17.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MioMvModel : NSObject
@property (nonatomic,copy) NSString * mv_id;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * singer_name;
@property (nonatomic,copy) NSString * singer_id;
@property (nonatomic,copy) NSString * mv_description;
@property (nonatomic,copy) NSString * mv_path;
@property (nonatomic,copy) NSString * cover_image_path;
@property (nonatomic,copy) NSString * hits_all;
@property (nonatomic,copy) NSString * comment_num;
@property (nonatomic, strong) NSArray *tags;


@end

NS_ASSUME_NONNULL_END
