//
//  MioLikeSonglistTableCell.m
//  573music
//
//  Created by Mimio on 2021/3/9.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioLikeSonglistTableCell.h"

@interface MioLikeSonglistTableCell()
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) UILabel *playCountLab;
@property (nonatomic, strong) MioLabel *songlistNameLab;
@property (nonatomic, strong) MioLabel *singerNameLab;
@property (nonatomic, strong) UIButton *likeBtn;
@end

@implementation MioLikeSonglistTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = appClearColor;
        _cover = [UIImageView creatImgView:frame(Mar, 6, 60, 60) inView:self.contentView image:@"qxt_yinyue" radius:4];
    
        _songlistNameLab = [MioLabel creatLabel:frame(_cover.right + Mar, 16, KSW - 92 - 60 , 22) inView:self.contentView text:@"" colorName:name_text_one size:16 alignment:NSTextAlignmentLeft];
        _playCountLab = [MioLabel creatLabel:frame(_cover.right + Mar, _songlistNameLab.bottom + 2, KSW - 92 - 60, 17) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];

        _likeBtn = [UIButton creatBtn:frame(KSW - 46, 20, 20, 20) inView:self.contentView bgImage:@"me_like_putong" action:nil];
        [_likeBtn setBackgroundImage:image(@"me_like_xuanzhon") forState:UIControlStateSelected];
    }
    return self;
}

- (void)setModel:(MioSongListModel *)model{
    [_cover sd_setImageWithURL:model.cover_image_path.mj_url placeholderImage:image(@"qxt_zhuanji")];
    _songlistNameLab.text = model.title;
    _playCountLab.text = [NSString stringWithFormat:@"%@次播放",model.hits_all];
    
    if (model.is_like) {
        _likeBtn.selected = YES;
    }else{
        _likeBtn.selected = NO;
    }
    
    [_likeBtn whenTapped:^{
        [MioPostReq(api_likes, (@{@"model_name":@"song_list",@"model_ids":@[model.song_list_id]})) success:^(NSDictionary *result){
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
