//
//  MioMusicTableCell.m
//  573music
//
//  Created by Mimio on 2020/12/17.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioMusicTableCell.h"

@interface MioMusicTableCell()
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) MioLabel *nameLab;
@property (nonatomic, strong) MioImageView *flacImg;
@property (nonatomic, strong) MioImageView *mvImg;
@property (nonatomic, strong) MioImageView *officialImg;
@property (nonatomic, strong) MioImageView *vipImg;
@property (nonatomic, strong) MioLabel *singerLab;
@property (nonatomic, strong) MioLabel *countLab;
@property (nonatomic, strong) MioImageView *countImg;
@property (nonatomic, strong) UIButton *likeBtn;
@end

@implementation MioMusicTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = appClearColor;
        _cover = [UIImageView creatImgView:frame(Mar, 0, 60, 60) inView:self.contentView image:@"" radius:4];
    
        _nameLab = [MioLabel creatLabel:frame(_cover.right + 8, 10, KSW - 84 - 45, 22) inView:self.contentView text:@"" colorName:name_text_one size:16 alignment:NSTextAlignmentLeft];
        _flacImg = [MioImageView creatImgView:frame(-100, _nameLab.bottom + 2.5, 22, 12) inView:self.contentView image:@"playlist_nondestructive" bgTintColorName:name_main radius:0];
        _mvImg = [MioImageView creatImgView:frame(-100, _nameLab.bottom + 2.5, 22, 12) inView:self.contentView image:@"playlist_mv" bgTintColorName:name_main radius:0];
        _officialImg = [MioImageView creatImgView:frame(-100, _nameLab.bottom + 2.5, 22, 12) inView:self.contentView image:@"playlist_zhengban" bgTintColorName:name_main radius:0];
        _vipImg = [MioImageView creatImgView:frame(-100, _nameLab.bottom + 2.5, 22, 12) inView:self.contentView image:@"playlist_vip" bgTintColorName:name_main radius:0];
        _singerLab = [MioLabel creatLabel:frame(_mvImg.right + 8, _nameLab.bottom + 0, KSW - 136 - 45, 17) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
//        MioImageView *icon = [MioImageView creatImgView:frame(KSW - 46, 10, 22, 22) inView:self image:@"play" bgTintColorName:name_icon_three radius:0];
        _countImg = [MioImageView creatImgView:frame(0, _nameLab.bottom + 1.5, 14, 14) inView:self.contentView image:@"dj_bf" bgTintColorName:name_main radius:0];
        _countLab = [MioLabel creatLabel:frame(KSW - 51, _nameLab.bottom + 1, 0, 15) inView:self.contentView text:@"" colorName:name_main size:12 alignment:NSTextAlignmentCenter];
        
        _likeBtn = [UIButton creatBtn:frame(KSW - 46, 20, 20, 20) inView:self.contentView bgImage:@"me_like_putong" action:nil];
        [_likeBtn setBackgroundImage:image(@"me_like_xuanzhon") forState:UIControlStateSelected];
    }
    return self;
}

- (void)setModel:(MioMusicModel *)model{
    [_cover sd_setImageWithURL:model.cover_image_path.mj_url placeholderImage:image(@"qxt_gequ")];
    _nameLab.text = model.title;
    _singerLab.text = model.singer_name;
    _countLab.text = model.hits_all;
    _countLab.width = [_countLab.text widthForFont:Font(12)];
    
    _flacImg.hidden = YES;
    _mvImg.hidden = YES;
    _officialImg.hidden = YES;
    _vipImg.hidden = YES;
    NSMutableArray *tagArr = [[NSMutableArray alloc] init];
    if (model.hasFlac) {
        _flacImg.hidden = NO;
        [tagArr addObject:_flacImg];
    }
    if (model.hasMV) {
        _mvImg.hidden = NO;
        [tagArr addObject:_mvImg];
    }
    if (model.official) {
        _officialImg.hidden = NO;
        [tagArr addObject:_officialImg];
    }
    if (model.need_vip) {
        _vipImg.hidden = NO;
        [tagArr addObject:_vipImg];
    }
    
    for (int i = 0;i < tagArr.count; i++) {
        ((UIView *)tagArr[i]).left = _cover.right + 8 + i * 26;
    }

    _countImg.left = _cover.right + 8 + tagArr.count * 26;
    _countLab.left = _countImg.right + 1;
    _singerLab.left = _countLab.right + 4;
    _singerLab.width = KSW - 84 - 45 - tagArr.count * 26 - 20 - _countLab.width -5;
    
    if (model.is_like) {
        _likeBtn.selected = YES;
    }else{
        _likeBtn.selected = NO;
    }
    
    [_likeBtn whenTapped:^{
        [MioPostReq(api_likes, (@{@"model_name":@"song",@"model_ids":@[model.song_id]})) success:^(NSDictionary *result){
            NSDictionary *data = [result objectForKey:@"data"];
            _likeBtn.selected = !_likeBtn.selected;
            if (_likeBtn.selected == YES) {
                [UIWindow showSuccess:@"已收藏到我的喜欢"];
            }else{
                [UIWindow showSuccess:@"已取消收藏"];
            }
            
        } failure:^(NSString *errorInfo) {
            [UIWindow showInfo:errorInfo];
        }];
    }];
}

@end
