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

/** 是否积分 */
@property (nonatomic, copy) NSString    *coin;

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
