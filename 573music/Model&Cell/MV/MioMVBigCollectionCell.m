//
//  MioMVBigCollectionCell.m
//  573music
//
//  Created by Mimio on 2021/1/5.
//  Copyright © 2021 Mimio. All rights reserved.
//

#import "MioMVBigCollectionCell.h"
@interface MioMVBigCollectionCell()
@property (nonatomic, strong) MioView *bgView;
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) UILabel *playCountLab;
@property (nonatomic, strong) MioLabel *titleLab;
@property (nonatomic, strong) MioLabel *singerLab;

@end

@implementation MioMVBigCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = appClearColor;
        _bgView = [MioView creatView:frame(0, 0, self.width, self.height) inView:self.contentView bgColorName:name_card radius:6];
        _cover = [UIImageView creatImgView:frame(0, 0, self.width, self.width * 10/17) inView:_bgView image:@"qxt_mv" radius:0];
        UIImageView *shadow = [UIImageView creatImgView:frame(0, _cover.height - 22, self.width, 22) inView:_cover image:@"zhuanji_mengban" radius:0];
        shadow.contentMode = UIViewContentModeScaleToFill;
        UIImageView *playCountIcon = [UIImageView creatImgView:frame(6, _cover.height - 15 , 11, 11) inView:_cover image:@"bofangliang" radius:0];
        _playCountLab = [UILabel creatLabel:frame(18, _cover.height - 17, 50, 15) inView:_cover text:@"0" color:appWhiteColor size:10 alignment:NSTextAlignmentLeft];
        _titleLab = [MioLabel creatLabel:frame(8, _cover.bottom + 6, self.width - 16, 20) inView:_bgView text:@"" colorName:name_text_one size:14 alignment:NSTextAlignmentLeft];
        _titleLab.numberOfLines = 2;
        _singerLab = [MioLabel creatLabel:frame(8, self.height - 17 - 7, self.width - 12, 17) inView:_bgView text:@"" colorName:name_text_two size:12 alignment:NSTextAlignmentLeft];
    }
    return self;
}

- (void)setModel:(MioMvModel *)model{
    [_cover sd_setImageWithURL:model.cover_image_path.mj_url placeholderImage:image(@"qxt_mv")];
    _playCountLab.text = model.hits_all;
    _titleLab.text = model.title;
    _singerLab.text = model.singer_name;
}
@end
