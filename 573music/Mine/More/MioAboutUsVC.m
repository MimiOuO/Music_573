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
    UIImageView *icon = [UIImageView creatImgView:frame(KSW/2 - 50, NavH + 34, 100, 100) inView:self.view image:@"ios-template-1024" radius:0];
    UILabel *titleLab = [UILabel creatLabel:frame(0, icon.bottom + 5, KSW, 30) inView:self.view text:@"多多陪玩" color:color_text_one size:22];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont boldSystemFontOfSize:22];
    
    UILabel *descLab = [UILabel creatLabel:frame(30, 227+ NavH, KSW - 60, 141) inView:self.view text:@"多多陪玩App汇聚了各个领域的高颜值技术大神，他(她)们通过专业的技能、优质的服务帮助用户练习游戏。节省用户的学习时间，体验更好的游戏乐趣。在多多陪玩App，用户不仅可以学习到新的技能，还可以通过注册成为大神共享自己的游戏技能，实现立马赚钱。" color:color_text_one size:16];
    descLab.numberOfLines = 0;
    
    UILabel *telLab = [UILabel creatLabel:frame(0, KSH - 70 - SafeBotH, KSW, 20) inView:self.view text:@"客服电话：028-86112645" color:color_text_one size:14];
    telLab.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *banquanLab = [UILabel creatLabel:frame(0, KSH - 35 - SafeBotH , KSW, 20) inView:self.view text:@"吉格斯科技版权所有 ©2019" color:color_text_two size:12];
    banquanLab.textAlignment = NSTextAlignmentCenter;

}


@end
