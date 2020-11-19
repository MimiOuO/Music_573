//
//  ZMUserInfo.h
//  ZMBCY
//
//  Created by ZOMAKE on 2018/1/6.
//  Copyright © 2018年 Brance. All rights reserved.
//

@interface MioUserInfo : NSObject

/** 用户ID */
@property (nonatomic, copy) NSString    *user_id;
/** 用户编号 */
@property (nonatomic, copy) NSString    *no;
/** 昵称 */
@property (nonatomic, copy) NSString    *nickname;
/** 手机 */
@property (nonatomic, copy) NSString    *phone;
/** 生日 */
@property (nonatomic, copy) NSString    *birthday;
/** 年龄 */
@property (nonatomic, copy) NSString    *age;
/** 头像地址 */
@property (nonatomic, copy) NSString    *avatar;

///** 声音 */
@property (nonatomic, copy) NSArray    *voice;
///** 视频地址 */
@property (nonatomic, copy) NSString    *auth_video_path;
///** 视频封面 */
@property (nonatomic, copy) NSString    *auth_video_cover;
///** 性别（0-女，1-男，2-未知） */
@property (nonatomic, assign) NSInteger gender;
///** 图片数组 */
@property (nonatomic, copy) NSArray    *photos;
///** 签名 */
@property (nonatomic, copy) NSString    *sign;
/** 是否登录 */
@property (nonatomic, assign) BOOL      isLogin;
/** 是否有实名 */
@property (nonatomic, assign) NSInteger had_auth;
/** 是否关注 */
@property (nonatomic, assign) NSInteger has_follow;
/** 关注数量 */
@property (nonatomic, assign) NSInteger follows_count;
/** 粉丝数量 */
@property (nonatomic, assign) NSInteger fans_count;
/** 足迹数量 */
@property (nonatomic, assign) NSInteger view_count;
/** 访客数量 */
@property (nonatomic, assign) NSInteger visit_count;
/** 粉丝数量 */
@property (nonatomic, assign) NSInteger post_count;
/** 是否是老师 */
@property (nonatomic, assign) int is_teacher;
/** 是否是老师 */
@property (nonatomic, copy) NSString *teacher_id;
/** 是否是机构 */
@property (nonatomic, assign) int is_org;
/**
 *  单例
 *
 *  @return 返回ZMUserInfo
 */
+ (instancetype)shareUserInfo;

/** 保存用户信息到沙盒 */
- (void)saveUserInfoToSandbox;



- (void)loginOut;

@end
