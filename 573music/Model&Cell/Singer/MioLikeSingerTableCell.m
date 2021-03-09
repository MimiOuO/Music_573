//
//  MioLikeSingerTableCell.m
//  573music
//
//  Created by Mimio on 2021/3/9.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioLikeSingerTableCell.h"
@interface MioLikeSingerTableCell()
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) MioLabel *singerNameLab;
@property (nonatomic, strong) MioLabel *fansCountLab;
@property (nonatomic, strong) UIButton *likeBtn;
@end
@implementation MioLikeSingerTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = appClearColor;
        
        _avatar = [UIImageView creatImgView:frame(Mar, 6, 56, 56) inView:self.contentView image:@"qxt_geshou" radius:28];
        
        _singerNameLab = [MioLabel creatLabel:frame(_avatar.right + 14, 14, KSW - 86 - 40 - 32, 22) inView:self.contentView text:@"" colorName:name_text_one size:16 alignment:NSTextAlignmentLeft];
        _fansCountLab = [MioLabel creatLabel:frame(_avatar.right + 14, _singerNameLab.bottom + 2, KSW - 92 - 60, 17) inView:self.contentView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
        _likeBtn = [UIButton creatBtn:frame(KSW - 46, 20, 20, 20) inView:self.contentView bgImage:@"me_like_putong" action:nil];
        [_likeBtn setBackgroundImage:image(@"me_like_xuanzhon") forState:UIControlStateSelected];
    }
    return self;
}

- (void)setModel:(MioSingerModel *)model{
    [_avatar sd_setImageWithURL:model.cover_image_path.mj_url placeholderImage:image(@"qxt_geshou")];
    _singerNameLab.text = model.singer_name;
    _fansCountLab.text = [NSString stringWithFormat:@"粉丝%@",model.like_num];
    
    if (model.is_like) {
        _likeBtn.selected = YES;
    }else{
        _likeBtn.selected = NO;
    }
    
    [_likeBtn whenTapped:^{
        [MioPostReq(api_likes, (@{@"model_name":@"singer",@"model_ids":@[model.singer_id]})) success:^(NSDictionary *result){
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
