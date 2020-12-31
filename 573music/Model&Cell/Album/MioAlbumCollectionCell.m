//
//  MioAlbumCollectionCell.m
//  573music
//
//  Created by Mimio on 2020/12/28.
//  Copyright © 2020 Mimio. All rights reserved.
//

#import "MioAlbumCollectionCell.h"

@interface MioAlbumCollectionCell()
@property (nonatomic, strong) UIImageView *coverImg;
@property (nonatomic, strong) UILabel *playCountLab;
@property (nonatomic, strong) MioLabel *albumNameLab;
@property (nonatomic, strong) MioLabel *singerNameLab;
@end

@implementation MioAlbumCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = appClearColor;
        NSLog(@"%f",self.contentView.width);
        CGFloat width = self.contentView.width;
        UIImageView *bgImg = [UIImageView creatImgView:frame(14, 0, width - 14,width - 14) inView:self.contentView image:@"zhuanji_heijiao" radius:0];
        _coverImg = [UIImageView creatImgView:frame(0, 0, width - 14, width - 14) inView:self.contentView image:@"" radius:4];
        UIImageView *shadow = [UIImageView creatImgView:frame(0, width - 14 - 22, width - 14, 22) inView:_coverImg image:@"zhuanji_mengban" radius:0];
        UIImageView *playCountImg = [UIImageView creatImgView:frame(6, width - 14 - 11 - 4, 11, 11) inView:_coverImg image:@"tinggeliang" radius:0];
        _playCountLab = [UILabel creatLabel:frame(18, width - 14 - 17, 80, 15) inView:_coverImg text:@"0" color:appWhiteColor size:10 alignment:NSTextAlignmentLeft];
        _albumNameLab = [MioLabel creatLabel:frame(0, width - 14 + 4, width, 17) inView:self.contentView text:@"" colorName:name_text_one size:12 alignment:NSTextAlignmentLeft];
        _singerNameLab = [MioLabel creatLabel:frame(0, width - 14 + 22, width, 14) inView:self.contentView text:@"" colorName:name_text_two size:10 alignment:NSTextAlignmentLeft];
    }
    return self;
}

- (void)setModel:(MioAlbumModel *)model{
    [_coverImg sd_setImageWithURL:[model.cover_image_path mj_url] placeholderImage:image(@"qxt_zhuanji")];
    _playCountLab.text = Str(model.hits_all);
    _albumNameLab.text = model.title;
    _singerNameLab.text = model.singer_name;
}

@end
