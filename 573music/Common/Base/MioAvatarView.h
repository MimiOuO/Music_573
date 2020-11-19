//
//  MioAvatarView.h
//  DuoDuoPeiwan
//
//  Created by Mimio on 2019/12/24.
//  Copyright © 2019 Brance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MioAvatarView : UIView
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIImageView *border;
+ (UIView *)creatAvatar:(CGRect)frame inView:(UIView *)view avatar:(NSString *)urlStr level:(NSString *)level;
- (instancetype)initFrame:(CGRect)frame inView:(UIView *)view;
-(void)setAvatar:(NSString *)urlStr level:(NSString *)level;
@end

NS_ASSUME_NONNULL_END
