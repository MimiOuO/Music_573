//
//  MioAvatarView.m
//  DuoDuoPeiwan
//
//  Created by Mimio on 2019/12/24.
//  Copyright © 2019 Brance. All rights reserved.
//

#import "MioAvatarView.h"

@interface MioAvatarView()

@end

@implementation MioAvatarView
+(UIView *)creatAvatar:(CGRect)frame inView:(UIView *)view avatar:(NSString *)urlStr level:(NSString *)level{
    UIView *avatarView = [UIView creatView:frame inView:view bgColor:appClearColor];
    UIImageView *avatar = [UIImageView creatImgView:frame(0, 0,frame.size.width, frame.size.width) inView:avatarView image:@"" radius:0];
    [avatar sd_setImageWithURL:urlStr.mj_url placeholderImage:image(@"icon")];
    ViewRadius(avatar, frame.size.width/2);
    UIImageView *border = [UIImageView creatImgView:frame(-(frame.size.width * 0.15) , -(frame.size.width * 0.15), frame.size.width * 1.3, frame.size.width * 1.3) inView:avatarView image:level radius:0];
    return avatarView;
}

- (instancetype)initFrame:(CGRect)frame inView:(UIView *)view{
    self = [super initWithFrame:frame];
    if (self) {
        self.avatar = [UIImageView creatImgView:frame(0, 0,frame.size.width, frame.size.width) inView:self image:@"icon" radius:0];
        ViewRadius(self.avatar, frame.size.width/2);
        self.border = [UIImageView creatImgView:frame(-(frame.size.width * 0.15) , -(frame.size.width * 0.15), frame.size.width * 1.3, frame.size.width * 1.3) inView:self image:@"" radius:0];
        [view addSubview:self];
    }
    return self;
}

-(void)setAvatar:(NSString *)urlStr level:(NSString *)level{
    [self.avatar sd_setImageWithURL:Url(urlStr) placeholderImage:image(@"icon")];
    self.border.image = image(level);
}

@end
