//
//  MioAboutUsVC.m
//  573music
//
//  Created by Mimio on 2021/1/6.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioAboutUsVC.h"

@interface MioAboutUsVC ()

@end

@implementation MioAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView.leftButton setImage:backArrowIcon forState:UIControlStateNormal];
    [self.navView.centerButton setTitle:@"关于我们" forState:UIControlStateNormal];
    
    [self creatUI];
}

-(void)creatUI{
    UIImageView *icon = [UIImageView creatImgView:frame(KSW/2 - 40, NavH + 34, 80, 100) inView:self.view image:@"aboutLogo" radius:0];
    UILabel *titleLab = [UILabel creatLabel:frame(0, icon.bottom + 5, KSW, 30) inView:self.view text:@"573音乐" color:color_text_one size:22];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont boldSystemFontOfSize:22];
    
    UILabel *descLab = [UILabel creatLabel:frame(30, 227+ NavH, KSW - 60, 141) inView:self.view text:@"573音乐是国内专业的网络音乐原创基地,平台内聚集了上千优质网络音乐人,为您提供优秀的Mc喊麦、网络歌曲、电子音乐、Mc伴奏、说唱歌曲等网络流行音乐试听,带给大家悦耳动听的音乐,全方位满足用户对网络流行音乐的试听需求。" color:color_text_one size:16];
    descLab.numberOfLines = 0;
    
    UILabel *telLab = [UILabel creatLabel:frame(0, KSH - 70 - SafeBotH, KSW, 20) inView:self.view text:[NSString stringWithFormat:@"当前版本：%@",[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]] color:color_text_one size:14];
    telLab.textAlignment = NSTextAlignmentCenter;
    
    
//    UILabel *banquanLab = [UILabel creatLabel:frame(0, KSH - 35 - SafeBotH , KSW, 20) inView:self.view text:@"吉格斯科技版权所有 ©2019" color:color_text_two size:12];
//    banquanLab.textAlignment = NSTextAlignmentCenter;

}


@end
