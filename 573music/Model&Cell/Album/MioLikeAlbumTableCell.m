//
//  MioLikeAlbumTableCell.m
//  573music
//
//  Created by Mimio on 2021/3/9.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioLikeAlbumTableCell.h"

@interface MioLikeAlbumTableCell()
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) UILabel *playCountLab;
@property (nonatomic, strong) MioLabel *albumNameLab;
@property (nonatomic, strong) MioLabel *singerNameLab;
@property (nonatomic, strong) UIButton *likeBtn;
@end

@implementation MioLikeAlbumTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = appClearColor;
        UIImageView *bg = [UIImageView creatImgView:frame(23, 6, 60, 60) inView:self.contentView image:@"zhuanji_heijiao" radius:0];
        _cover = [UIImageView creatImgView:frame(Mar, 6, 60, 60) inView:self.contentView image:@"qxt_zhuanji" radius:4];
    
        _albumNameLab = [MioLabel creatLabel:frame(_cover.right + Mar, 16, self.width - 92 - 60, 22) inView:self.contentView text:@"" colorName:name_text_one size:16 alignment:NSTextAlignmentLeft];
        _singerNameLab = [MioLabel creatLabel:frame(_cover.right + Mar, _albumNameLab.bottom + 2, self.width - 92 - 60, 17) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
        _playCountLab = [MioLabel creatLabel:frame(self.width - 12 - 100 , 40, 100, 17) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentRight];
        _likeBtn = [UIButton creatBtn:frame(KSW - 46, 20, 20, 20) inView:self.contentView bgImage:@"me_like_putong" action:nil];
        [_likeBtn setBackgroundImage:image(@"me_like_xuanzhon") forState:UIControlStateSelected];
    }
    return self;
}

- (void)setModel:(MioAlbumModel *)model{
    _albumNameLab.width = self.width - 92 - 60;
    _singerNameLab.width = self.width - 92 - 60;
    _playCountLab.left = self.width - 12 - 100;
    
    [_cover sd_setImageWithURL:model.cover_image_path.mj_url placeholderImage:image(@"qxt_zhuanji")];
    _albumNameLab.text = model.title;
    _singerNameLab.text = [NSString stringWithFormat:@"%@·%@次播放",model.singer_name,model.hits_all];
//    _playCountLab.text = [NSString stringWithFormat:@"%@",];
    if (model.is_like) {
        _likeBtn.selected = YES;
    }else{
        _likeBtn.selected = NO;
    }
    
    [_likeBtn whenTapped:^{
        [MioPostReq(api_likes, (@{@"model_name":@"album",@"model_ids":@[model.album_id]})) success:^(NSDictionary *result){
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
