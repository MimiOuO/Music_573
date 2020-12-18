//
//  MioMineVC.m
//  jgsschool
//
//  Created by Mimio on 2020/9/18.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMineVC.h"

@interface MioMineVC ()
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIImageView *gender;
@property (nonatomic, strong) MioButton *editBtn;
@property (nonatomic, strong) MioLabel *nicknameLab;
@property (nonatomic, strong) MioLabel *signLab;
@property (nonatomic, strong) MioView *LvBg;
@property (nonatomic, strong) MioView *listenTime;
@property (nonatomic, strong) MioLabel *LvLab;
@property (nonatomic, strong) MioImageView *listenIcon;
@property (nonatomic, strong) MioLabel *listenLab;
@end

@implementation MioMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}



-(void)creatUI{
    MioLabel *titleLab = [MioLabel creatLabel:frame(Mar, StatusH + 8, 50, 28) inView:self.view text:@"我的" colorName:name_main boldSize:20 alignment:NSTextAlignmentLeft];
    MioButton *messegeBtn = [MioButton creatBtn:frame(KSW - 56 - 20, StatusH + 12, 20, 20) inView:self.view bgImage:@"me_yidu" bgTintColorName:name_icon_one action:^{
        
    }];
    MioButton *moreBtn = [MioButton creatBtn:frame(KSW - 16 - 20, StatusH + 12, 20, 20) inView:self.view bgImage:@"me_more" bgTintColorName:name_icon_one action:^{
        
    }];

    UIScrollView *bgScroll = [UIScrollView creatScroll:frame(0, NavH, KSW, KSH - NavH - TabH - 50) inView:self.view contentSize:CGSizeMake(KSW, 698)];
    MioView *userBgView = [MioView creatView:frame(Mar,31, KSW_Mar2, 136) inView:bgScroll bgColorName:name_sup_one radius:8];
    _avatar = [UIImageView creatImgView:frame(Mar + 12, 20, 70, 70) inView:bgScroll image:@"icon" radius:35];
    
    
}


@end
