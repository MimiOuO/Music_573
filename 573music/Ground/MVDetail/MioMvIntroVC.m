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
@property (nonatomic, strong) UIView *relatedView;
@property (nonatomic, strong) UIButton *likeBtn;
@end

@implementation MioMvIntroVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImg.hidden = YES;
    self.view.backgroundColor = appClearColor;
}

- (void)setMv:(MioMvModel *)mv{
    _mv = mv;
    [self.view removeAllSubviews];
    _scroll = [UIScrollView creatScroll:frame(0, 0, KSW, KSH - StatusH - KSW *9/16 - 44) inView:self.view contentSize:CGSizeMake(KSW, 1000)];
    _relatedView = [UIView creatView:frame(0, 0, KSW, 6 * 73) inView:_scroll bgColor:appClearColor radius:0];
    UIImageView *avatar = [UIImageView creatImgView:frame(Mar, 12, 46, 46) inView:_scroll image:@"" radius:23];
    [avatar sd_setImageWithURL:Url(mv.singer[@"cover_image_path"]) placeholderImage:image(@"qxt_geshou")];
    MioLabel *nameLab = [MioLabel creatLabel:frame(71, 17, KSW - 71 - 120, 20) inView:_scroll text:mv.singer_name colorName:name_text_one boldSize:14 alignment:NSTextAlignmentLeft];
    UILabel *fansLab = [UILabel creatLabel:frame(71, 37, 200, 17) inView:_scroll text:[NSString stringWithFormat:@"%@粉丝",mv.singer[@"like_num"]] color:color_text_two size:12 alignment:NSTextAlignmentLeft];
    UILabel *contentLab = [UILabel creatLabel:frame(Mar, 70, KSW_Mar2, 20) inView:_scroll text:mv.title color:color_text_one boldSize:14 alignment:NSTextAlignmentLeft];
    UILabel *playCountLab  = [UILabel creatLabel:frame(Mar, 98, KSW_Mar2, 17) inView:_scroll text:[NSString stringWithFormat:@"%@次播放",mv.hits_all] color:color_text_two size:12 alignment:NSTextAlignmentLeft];
    
//    MioButton *DowloadBtn = [MioButton creatBtn:frame(KSW-72 - 20, Mar, 20, 20) inView:_scroll bgImage:@"download_player" bgTintColorName:name_icon_one action:^{
//        
//    }];

    _likeBtn = [MioButton creatBtn:frame(KSW-18 - 20, Mar, 20, 20) inView:_scroll bgImage:@"me_like_putong" bgTintColorName:name_icon_one action:^{
        [self likeClick];
    }];
    [_likeBtn setBackgroundImage:image(@"me_like_xuanzhon") forState:UIControlStateSelected];
    if (mv.is_like) {
        _likeBtn.selected = YES;
    }
//    UILabel *downloadLab = [UILabel creatLabel:frame(DowloadBtn.left -5 , 37, 30, 17) inView:_scroll text:@"下载" color:color_text_two size:12 alignment:NSTextAlignmentCenter];
    UILabel *likeLab = [UILabel creatLabel:frame(_likeBtn.left -5 , 37, 30, 17) inView:_scroll text:@"喜欢" color:color_text_two size:12 alignment:NSTextAlignmentCenter];
    
    
    UILabel *relatLab  = [UILabel creatLabel:frame(Mar, 135, KSW_Mar2, 20) inView:_scroll text:@"相关推荐" color:color_text_one boldSize:14 alignment:NSTextAlignmentLeft];

    [self requestRelated];
}

-(void)requestRelated{
    
    [MioGetReq(api_mvRelated(_mv.mv_id), @{@"k":@"v"}) success:^(NSDictionary *result){
        NSArray *data = [result objectForKey:@"data"];
        
        self.relatedMVArr = [MioMvModel mj_objectArrayWithKeyValuesArray:data];
        [_relatedView removeAllSubviews];
        for (int i = 0;i < data.count; i++) {
            MioMvModel *model = [MioMvModel mj_objectWithKeyValues:data[i]];
            UIView *mvView = [UIView creatView:frame(0, 163 + 73*i, KSW, 61) inView:_relatedView bgColor:appClearColor radius:0];
            UIImageView *cover = [UIImageView creatImgView:frame(Mar, 6, 109, 61) inView:mvView image:@"qxt_mv" radius:4];
            UIImageView *shadow = [UIImageView creatImgView:frame(0, cover.height - 22, 109, 22) inView:cover image:@"zhuanji_mengban" radius:0];
            shadow.contentMode = UIViewContentModeScaleToFill;
            [cover sd_setImageWithURL:model.cover_image_path.mj_url placeholderImage:image(@"qxt_mv")];
            UIImageView *playCountIcon = [UIImageView creatImgView:frame(6, cover.height - 15 , 11, 11) inView:cover image:@"bofangliang" radius:0];
            UILabel *playCountLab = [UILabel creatLabel:frame(18, cover.height - 17, 50, 15) inView:cover text:model.hits_all color:appWhiteColor size:10 alignment:NSTextAlignmentLeft];
            MioLabel *titleLab = [MioLabel creatLabel:frame(133, 14, KSW - 133 - Mar, 22) inView:mvView text:model.title colorName:name_text_one size:14 alignment:NSTextAlignmentLeft];
            MioLabel *singerLab = [MioLabel creatLabel:frame(133, 40, KSW - 133 - Mar, 17) inView:mvView text:model.singer_name colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
            _scroll.contentSize = CGSizeMake(KSW, data.count * 73 + 180);
            
            [mvView whenTapped:^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(changeMV:)]) {
                    [self.delegate changeMV:model.mv_id];
                }
            }];
        }
    } failure:^(NSString *errorInfo) {}];
}

-(void)likeClick{
    [MioPostReq(api_likes, (@{@"model_name":@"mv",@"model_ids":@[_mv.mv_id]})) success:^(NSDictionary *result){
        NSDictionary *data = [result objectForKey:@"data"];
        _likeBtn.selected = !_likeBtn.selected;
        [UIWindow showSuccess:@"操作成功"];
    } failure:^(NSString *errorInfo) {
        [UIWindow showInfo:errorInfo];
    }];
}
@end
