//
//  MioCmtModel.h
//  573music
//
//  Created by Mimio on 2021/1/4.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MioCmtModel : NSObject
@property (nonatomic, strong) MioUserInfo *from_user;
@property (nonatomic, strong) MioUserInfo *to_user;
@property (nonatomic,copy) NSString * comment_id;
@property (nonatomic,copy) NSString * commentable_id;
@property (nonatomic,copy) NSString * post_id;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,copy) NSString * created_at;
@property (nonatomic, strong) NSArray *sub_comments;
@property (nonatomic, copy) NSString * isBendi;
@end

NS_ASSUME_NONNULL_END
