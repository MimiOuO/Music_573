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
@property (nonatomic,copy) NSString * user_id;
@property (nonatomic,copy) NSString * teacher_id;
@property (nonatomic,copy) NSString * organization_id;
@property (nonatomic,copy) NSString * mv_category_id;
@property (nonatomic,copy) NSString * mv_category_name;
@property (nonatomic,copy) NSString * mv_name;
@property (nonatomic,copy) NSString * mv_cover_image;
@property (nonatomic,copy) NSString * mv_desc;
@property (nonatomic,copy) NSString * praise_num;
@property (nonatomic,copy) NSString * study_num;
@property (nonatomic,copy) NSString * share_num;
@property (nonatomic,copy) NSString * comment_num;
@property (nonatomic,copy) NSString * mv_hot;
@property (nonatomic,copy) NSString * mv_recommend;
@property (nonatomic,copy) NSString * recommend_at;
@property (nonatomic,copy) NSString * mv_status;
@property (nonatomic,copy) NSString * is_finish;
@property (nonatomic,copy) NSString * all_episode;
@property (nonatomic,copy) MioUserInfo * user;
@property (nonatomic, assign) int collections_count;
@property (nonatomic, strong) NSArray *collections;
@property (nonatomic, assign) int last_episode;
@property (nonatomic, assign) int had_like;
@end

NS_ASSUME_NONNULL_END
