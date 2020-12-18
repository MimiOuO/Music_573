//
//  MioCourseIntroVC.m
//  jgsschool
//
//  Created by Mimio on 2020/9/17.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMvIntroVC.h"
#import "LEECoolButton.h"
#import "MioMvVC.h"
@interface MioMvIntroVC ()
@property (nonatomic, strong) UIScrollView *scroll;
@end

@implementation MioMvIntroVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setCourse:(MioMvModel *)mv{
    _scroll = [UIScrollView creatScroll:frame(0, 0, KSW, KSH - StatusH - KSW *9/16 - 48) inView:self.view contentSize:CGSizeMake(KSW, 1000)];
    UIView *mvView = [UIView creatView:frame(0, 0, KSW, 142) inView:_scroll bgColor:appWhiteColor radius:0];
    UILabel *titleLab = [UILabel creatLabel:frame(Mar, Mar, 240, 16) inView:mvView text:mv.mv_name color:subColor boldSize:16 alignment:NSTextAlignmentLeft];
    titleLab.height = [titleLab.text heightForFont:BoldFont(16) width:KSW];
    UILabel *typeLab = [UILabel creatLabel:frame(Mar, 40, 240, 12) inView:mvView text:[NSString stringWithFormat:@"%@·%@",mv.mv_category_name,mv.mv_name] color:grayTextColor size:12 alignment:NSTextAlignmentLeft];
    UILabel *introLab = [UILabel creatLabel:frame(Mar, 64, KSW_Mar2, 0) inView:mvView text:mv.mv_desc color:subColor size:14 alignment:NSTextAlignmentLeft];
    introLab.numberOfLines = 0;
    introLab.height = [introLab.text heightForFont:Font(14) width:KSW_Mar2];
    
    UIButton *shareBtn = [UIButton creatBtn:frame(56, introLab.bottom + 22, 18, 18) inView:mvView bgImage:@"dynamic_share_icon" action:^{
        
    }];
    UILabel *shareLab = [UILabel creatLabel:frame(0, shareBtn.bottom + 5, 30, 12) inView:mvView text:mv.share_num color:grayTextColor size:12    alignment:NSTextAlignmentCenter];
    shareLab.centerX = shareBtn.centerX;
    
    UIButton *studyBtn = [UIButton creatBtn:frame(KSW2 - 17.5/2, introLab.bottom + 22, 17.5, 18) inView:mvView bgImage:@"dynamic_learning_icon" action:^{
        
    }];
    UILabel *studyLab = [UILabel creatLabel:frame(0, shareBtn.bottom + 5, 30, 12) inView:mvView text:mv.study_num color:grayTextColor size:12    alignment:NSTextAlignmentCenter];
    studyLab.centerX = studyBtn.centerX;
    
    LEECoolButton *likeBtn = [LEECoolButton coolButtonWithImage:[UIImage imageNamed:@"dynamic_like_icon"] ImageFrame:CGRectMake(0, 0, 20.5, 18)];
    likeBtn.frame = frame(KSW - 56 -20.5, introLab.bottom + 22, 20.5, 18);
    likeBtn.imageColorOn = [UIColor colorWithRed:254/255.0f green:55/255.0f blue:23/255.0f alpha:1.0f];
    likeBtn.circleColor = [UIColor colorWithRed:255/255.0f green:55/255.0f blue:23/255.0f alpha:1.0f];
    likeBtn.lineColor = [UIColor colorWithRed:226/255.0f green:96/255.0f blue:96/255.0f alpha:1.0f];

    [mvView addSubview:likeBtn];
    UIImageView *likeCover = [UIImageView creatImgView:frame(0, 0, 20.5, 18) inView:likeBtn image:@"dynamic_like_icon" radius:0];
    
    
    if (mv.had_like) {
        likeBtn.selected = YES;
        likeCover.hidden = YES;
    }else{
        likeBtn.selected = NO;
        likeCover.hidden = NO;
    }
    
    UILabel *likeLab = [UILabel creatLabel:frame(0, shareBtn.bottom + 5, 30, 12) inView:mvView text:mv.praise_num color:grayTextColor size:12    alignment:NSTextAlignmentCenter];
    likeLab.centerX = likeBtn.centerX;

    
    [likeBtn whenTapped:^{
        if (likeBtn.selected) {
            [likeBtn deselect];
            likeCover.hidden = NO;
            likeLab.text = [NSString stringWithFormat:@"%ld",[likeLab.text integerValue] - 1];
        }else{
            [likeBtn select];
            likeCover.hidden = YES;
            likeLab.text = [NSString stringWithFormat:@"%ld",[likeLab.text integerValue] + 1];
        }
    }];
    mvView.height = introLab.height + 142;
    
    UIButton *joinBtn = [UIButton creatBtn:frame(KSW - Mar - 80, 16, 80, 32) inView:mvView bgColor:color_main title:@"加入学习" titleColor:appWhiteColor font:12 radius:5 action:^{
        
    }];
    
    UIView *avatarView = [UIView creatView:frame(0, mvView.bottom + 8, KSW, 56) inView:_scroll bgColor:appWhiteColor radius:0];
    UIImageView *avatar = [UIImageView creatImgView:frame(Mar, 8, 40, 40) inView:avatarView image:@"" radius:20];
    [avatar sd_setImageWithURL:Url(mv.user.avatar) placeholderImage:image(@"icon")];
    UILabel *nickName = [UILabel creatLabel:frame(avatar.right + 8, 12, 0, 14) inView:avatarView text:mv.user.nickname color:subColor boldSize:14 alignment:NSTextAlignmentLeft];
    nickName.width = [nickName.text widthForFont:BoldFont(14)];
    UILabel *fansLab = [UILabel creatLabel:frame(avatar.right + 8, 32, 100, 12) inView:avatarView text:@"12人关注" color:grayTextColor size:12 alignment:NSTextAlignmentLeft];
    __block UIButton *followBtn = [UIButton creatBtn:frame(KSW - 56 - Mar, 16, 56, 24) inView:avatarView bgColor:appWhiteColor title:@"关注" titleColor:color_main font:12 radius:5 action:^{
        followBtn.selected = !followBtn.selected;
    }];
    followBtn.layer.borderColor = color_main.CGColor;
    followBtn.layer.borderWidth = 1;
    [followBtn setBackgroundColor:color_main forState:UIControlStateSelected];
    [followBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [followBtn setTitleColor:appWhiteColor forState:UIControlStateSelected];
    
    
    //======================================================================//
    //                              分集
    //======================================================================//
    UIView *episodeView = [UIView creatView:frame(0, avatarView.bottom + 8, KSW, 120) inView:_scroll bgColor:appWhiteColor radius:0];
    UILabel *episodeLab = [UILabel creatLabel:frame(Mar, 8, 34, 16) inView:episodeView text:@"选集" color:subColor boldSize:16 alignment:NSTextAlignmentLeft];
    UILabel *episodeCountLab = [UILabel creatLabel:frame(episodeLab.right + 8, 10, 50, 14) inView:episodeView text:[NSString stringWithFormat:@"共%d集",mv.collections_count] color:grayTextColor size:14 alignment:NSTextAlignmentLeft];
    UIScrollView *episodeScroll = [UIScrollView creatScroll:frame(0, 32, KSW, 80) inView:episodeView contentSize:CGSizeMake(mv.collections_count * 152 + Mar2, 80)];
    for (int i = 0; i < mv.collections.count; i ++) {
        __block UIButton *collectionBtn = [UIButton creatBtn:frame(Mar + 152*i, 0, 144, 80) inView:episodeScroll bgImage:@"details_bg" action:^{
            if (collectionBtn.selected == YES) {
                return;
            }
            for (int j = 1 ; j< mv.collections.count + 1; j ++) {
                UIButton *btn = (UIButton *)[self.view viewWithTag:j];
                btn.selected = NO;
            }
            collectionBtn.selected = YES;
            if ([self.delegate respondsToSelector:@selector(changeCollection:)]) {
                [self.delegate changeCollection:(collectionBtn.tag - 1)];
            }
            
        }];
        collectionBtn.tag = i + 1;
        if (Equals([mv.collections[i] objectForKey:@"episode"], mv.last_episode)) {
            collectionBtn.selected = YES;
        }
        [collectionBtn setBackgroundImage:image(@"details_icon_play") forState:UIControlStateSelected];
        UILabel *titleLab = [UILabel creatLabel:frame(8, 8, 128, 0) inView:collectionBtn text:[mv.collections[i] objectForKey:@"collection_name"] color:subColor size:14 alignment:NSTextAlignmentLeft];
        titleLab.numberOfLines = 2;
        titleLab.height = [titleLab.text heightForFont:Font(14) width:128];
        UILabel *durationLab = [UILabel creatLabel:frame(8, 60, 128, 12) inView:collectionBtn text:@"20:00" color:grayTextColor size:12 alignment:NSTextAlignmentRight];
    }
}

@end
