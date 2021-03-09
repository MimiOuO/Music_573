//
//  MioLikeMVTableCell.m
//  573music
//
//  Created by Mimio on 2021/3/9.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioLikeMVTableCell.h"

@interface MioLikeMVTableCell()
@property (nonatomic, strong) MioView *bgView;
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) UILabel *playCountLab;
@property (nonatomic, strong) MioLabel *titleLab;
@property (nonatomic, strong) MioLabel *singerLab;
@property (nonatomic, strong) UIButton *likeBtn;
@end
@implementation MioLikeMVTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = appClearColor;
        
        _cover = [UIImageView creatImgView:frame(Mar, 6, 109, 61) inView:self.contentView image:@"qxt_mv" radius:4];
        UIImageView *shadow = [UIImageView creatImgView:frame(0, _cover.height - 22, 109, 22) inView:_cover image:@"gedan_mengbang" radius:0];
        shadow.contentMode = UIViewContentModeScaleToFill;
        UIImageView *playCountIcon = [UIImageView creatImgView:frame(6, _cover.height - 15 , 11, 11) inView:_cover image:@"bofangliang" radius:0];
        _playCountLab = [UILabel creatLabel:frame(18, _cover.height - 17, 50, 15) inView:_cover text:@"0" color:appWhiteColor size:10 alignment:NSTextAlignmentLeft];
        _titleLab = [MioLabel creatLabel:frame(133, 14, self.width - 133 - 32 - Mar, 22) inView:self.contentView text:@"" colorName:name_text_one size:14 alignment:NSTextAlignmentLeft];
        _singerLab = [MioLabel creatLabel:frame(133, 40, self.width - 133 - Mar, 17) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
        _likeBtn = [UIButton creatBtn:frame(KSW - 46, 26, 20, 20) inView:self.contentView bgImage:@"me_like_putong" action:nil];
        [_likeBtn setBackgroundImage:image(@"me_like_xuanzhon") forState:UIControlStateSelected];
    }
    return self;
}

- (void)setModel:(MioMvModel *)model{
    _titleLab.width = self.width - 133 - Mar - 32;
    _singerLab.width = self.width - 133 - Mar - 32;
    
    [_cover sd_setImageWithURL:model.cover_image_path.mj_url placeholderImage:image(@"qxt_mv")];
    _playCountLab.text = model.hits_all;
    _titleLab.text = model.title;
    _singerLab.text = model.singer_name;
    
    if (model.is_like) {
        _likeBtn.selected = YES;
    }else{
        _likeBtn.selected = NO;
    }
    
    [_likeBtn whenTapped:^{
        [MioPostReq(api_likes, (@{@"model_name":@"mv",@"model_ids":@[model.mv_id]})) success:^(NSDictionary *result){
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
