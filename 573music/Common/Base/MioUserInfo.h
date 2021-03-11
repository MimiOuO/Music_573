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

///** 性别（0-女，1-男，2-未知） */
@property (nonatomic, assign) NSInteger gender;
///** 签名 */
@property (nonatomic, copy) NSString    *sign;
/** 是否登录 */
@property (nonatomic, assign) BOOL      isLogin;

/** 积分 */
@property (nonatomic, copy) NSString    *coin;

/** 听歌时长 */
@property (nonatomic, copy) NSString    *listen_time;


/** 等级 */
@property (nonatomic, copy) NSString    *level;
/** 分享链接 */
@property (nonatomic, copy) NSString    *share_url;
/** 兴趣 */
@property (nonatomic, strong) NSArray    *favorite_tags;

@property (nonatomic, assign) NSInteger is_vip;
/** VIP剩余 */
@property (nonatomic, copy) NSString    *vip_remain;
/** VIP剩余格式化 */
@property (nonatomic, copy) NSString    *vip_remain_format;

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
